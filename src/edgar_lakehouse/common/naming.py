"""Column and field name normalization shared across ingestion and transforms."""

import re

# A word boundary is either a lower/digit-to-upper transition (camelCase) or the
# end of an acronym run followed by a capitalized word (XBRLTag -> XBRL_Tag).
_CASE_BOUNDARY = re.compile(r"(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])")
_NON_ALNUM = re.compile(r"[^0-9a-zA-Z]+")


def to_snake_case(name: str) -> str:
    """Normalize an arbitrary field name to snake_case.

    EDGAR XBRL tags arrive as PascalCase with acronym runs
    ("AccountsPayableCurrent", "XBRLNote"), while other sources use spaces or
    mixed separators: all of them must map to one stable column naming scheme.
    """
    with_boundaries = _CASE_BOUNDARY.sub("_", name.strip())
    return _NON_ALNUM.sub("_", with_boundaries).strip("_").lower()
