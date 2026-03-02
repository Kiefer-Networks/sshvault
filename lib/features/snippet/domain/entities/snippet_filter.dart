class SnippetFilter {
  final String? searchQuery;
  final String? groupId;
  final List<String>? tagIds;
  final String? language;

  const SnippetFilter({
    this.searchQuery,
    this.groupId,
    this.tagIds,
    this.language,
  });

  SnippetFilter copyWith({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
    bool clearSearch = false,
    bool clearGroup = false,
    bool clearLanguage = false,
  }) {
    return SnippetFilter(
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      groupId: clearGroup ? null : (groupId ?? this.groupId),
      tagIds: tagIds ?? this.tagIds,
      language: clearLanguage ? null : (language ?? this.language),
    );
  }
}
