"""Live agent regression. Requires paramiko in the invoking Python environment.

Usage: python tool/verify_ssh_agent.py /absolute/path/to/dart.exe
Adds only a generated temporary key to the running agent and removes it in finally.
"""
import base64
import hashlib
import pathlib
import socket
import subprocess
import sys
import struct
import tempfile
import threading
import time

import paramiko
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey


def main():
    root = pathlib.Path(__file__).resolve().parent.parent
    with tempfile.TemporaryDirectory(prefix="sshvault-agent-key-") as temp:
        key_path = pathlib.Path(temp) / "identity"
        key = Ed25519PrivateKey.generate()
        private_pem = key.private_bytes(serialization.Encoding.PEM,
            serialization.PrivateFormat.OpenSSH, serialization.NoEncryption())
        public = key.public_key().public_bytes(serialization.Encoding.OpenSSH,
            serialization.PublicFormat.OpenSSH)
        public_path = key_path.with_suffix(".pub")
        public_path.write_bytes(public)
        expected = base64.b64decode(public.split()[1])
        host_key = paramiko.RSAKey.generate(2048)
        fingerprint = base64.b64encode(hashlib.sha256(host_key.asbytes()).digest()).decode()
        listener = socket.socket()
        listener.bind(("127.0.0.1", 0))
        listener.listen(1)
        listener.settimeout(30)
        server_errors = []

        class Server(paramiko.ServerInterface):
            def __init__(self):
                self.exec_requested = threading.Event()
                self.forwarding = False

            def check_channel_forward_agent_request(self, channel):
                self.forwarding = True
                return True

            def get_allowed_auths(self, username):
                return "publickey"

            def check_auth_publickey(self, username, key):
                return (paramiko.AUTH_SUCCESSFUL if username == "sshvault-audit"
                    and key.asbytes() == expected else paramiko.AUTH_FAILED)

            def check_channel_request(self, kind, channel_id):
                return (paramiko.OPEN_SUCCEEDED if kind == "session"
                    else paramiko.OPEN_FAILED_ADMINISTRATIVELY_PROHIBITED)

            def check_channel_exec_request(self, channel, command):
                if command != b"agent-auth-check":
                    return False
                self.exec_requested.set()
                return True

        def serve():
            try:
                connection, _ = listener.accept()
                with paramiko.Transport(connection) as transport:
                    transport.add_server_key(host_key)
                    server = Server()
                    transport.start_server(server=server)
                    channel = transport.accept(15)
                    if channel is None or not server.exec_requested.wait(15):
                        raise RuntimeError("Client did not authenticate and execute command")
                    if not server.forwarding:
                        raise RuntimeError("Client did not request agent forwarding")
                    agent = transport.open_channel("auth-agent@openssh.com", timeout=10)
                    agent.settimeout(10)

                    def exchange(payload):
                        agent.sendall(struct.pack('>I', len(payload)) + payload)
                        def receive(size):
                            result = b''
                            while len(result) < size:
                                chunk = agent.recv(size - len(result))
                                if not chunk:
                                    raise RuntimeError('Truncated agent reply')
                                result += chunk
                            return result
                        size = struct.unpack('>I', receive(4))[0]
                        return paramiko.Message(receive(size))

                    identities = exchange(bytes([11]))
                    if identities.get_byte() != bytes([12]):
                        raise RuntimeError('Agent did not list identities')
                    blobs = []
                    for _ in range(identities.get_int()):
                        blobs.append(identities.get_string())
                        identities.get_string()
                    if expected not in blobs:
                        raise RuntimeError('Temporary key absent from forwarded agent')
                    challenge = b'sshvault-forwarding-regression'
                    request = paramiko.Message()
                    request.add_byte(bytes([13]))
                    request.add_string(expected)
                    request.add_string(challenge)
                    request.add_int(0)
                    signature = exchange(request.asbytes())
                    if signature.get_byte() != bytes([14]):
                        raise RuntimeError('Forwarded agent refused signature')
                    public_key = paramiko.Ed25519Key(data=expected)
                    if not public_key.verify_ssh_sig(challenge, paramiko.Message(signature.get_string())):
                        raise RuntimeError('Forwarded signature invalid')
                    agent.close()
                    channel.sendall("agent-auth-ok ä😀\n".encode())
                    channel.send_exit_status(0)
                    channel.shutdown_write()
                    channel.close()
                    deadline = time.monotonic() + 5
                    while transport.is_active() and time.monotonic() < deadline:
                        time.sleep(0.02)
            except Exception as error:
                server_errors.append(error)

        added = False
        worker = threading.Thread(target=serve, daemon=True)
        try:
            result = subprocess.run(["ssh-add", "-"], input=private_pem, capture_output=True)
            if result.returncode:
                raise RuntimeError(result.stderr.decode(errors="replace"))
            added = True
            worker.start()
            subprocess.run([sys.argv[1], "--packages=" + str(root / ".dart_tool/package_config.json"),
                str(root / "tool/verify_ssh_agent.dart"), str(listener.getsockname()[1]),
                str(public_path), fingerprint], check=True, cwd=root, timeout=45)
            worker.join(5)
            if server_errors:
                raise server_errors[0]
        finally:
            listener.close()
            if added:
                subprocess.run(["ssh-add", "-d", str(public_path)], check=True, capture_output=True)


if __name__ == "__main__":
    main()
