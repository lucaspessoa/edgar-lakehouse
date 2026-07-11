import pytest

from edgar_lakehouse.common.naming import to_snake_case


@pytest.mark.parametrize(
    ("raw", "expected"),
    [
        ("AccountsPayableCurrent", "accounts_payable_current"),
        ("camelCaseField", "camel_case_field"),
        ("XBRLNote", "xbrl_note"),
        ("Total Assets", "total_assets"),
        ("net--income  (loss)", "net_income_loss"),
        ("already_snake_case", "already_snake_case"),
        ("Q4Revenue", "q4_revenue"),
    ],
)
def test_to_snake_case(raw: str, expected: str) -> None:
    assert to_snake_case(raw) == expected


@pytest.mark.parametrize("degenerate", ["", "   ", "---", "_"])
def test_degenerate_names_collapse_to_empty(degenerate: str) -> None:
    assert to_snake_case(degenerate) == ""


def test_idempotent_on_own_output() -> None:
    once = to_snake_case("OperatingIncomeLoss")
    assert to_snake_case(once) == once
