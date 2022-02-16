# mono2ledger
This is python script that i use to convert bank statements from
[monobank](https://monobank.ua/) to [ledger-cli](https://www.ledger-cli.org/)
entries.

It takes list of files as input, and uses options from config file located at
`$XDG_CONFIG_HOME/mono2ledger/config.ini` or `~/.config/mono2ledger/config.ini`
to set script options, setup account names and payees to be associated with
entries in statements.

This script should never override ledger file, only append to it.

## Not implemented/TODO
- Handling of exchanges between currencies and any other currencies other than
  UAH. Script has some checks to prevert such entries from breaking parser and
  it will error out in case it finds such values
- Combining several operations on same day with same payees into single
  ledger entries. This should make output a bit prettier
- Specifying config file with command-line flag

## Usage:
```shell
usage: mono2ledger [-h] [-n] PATH [PATH ...]

Convert monobank csv statement to ledger transactions.

positional arguments:
  PATH           Path to monobank card statement.

optional arguments:
  -h, --help     show this help message and exit
  -n, --no-edit  Do not edit ledger files, just print output as if they were
```

## Example config with descriptions of options in comments:
```ini
# DEFAULT section contains script options
[DEFAULT]
# Account name used for credit card
card_account=Assets:Credit Card
# Account name used for cashback
cashback_account=income:cashback:credit_card
# Ledger file to which converted output will be appended
ledger_file=~/.local/share/ledger/journal.ledger
# All other sections have format <MCC>/<regexp>
# Where MCC matches MCC of entry and regexp (uses python regexp)
# matches description of entry.
# Be aware that regexps are matched in order they are defined, so if you
# define entry that matches everyting (.*) and then define entry that matches
# specific description below it, it will always use first match

# Each section has following fields:
# income: Account used when operation is income (you get money from somewhere)
# outcome: Account used when operation is outcome (you spend money somewhere)
# payee: Payee name used for entry, can be ommited, in that case script will
# set it to UNKNOWN and notify about it when converting
# outcome and income keys may be ommited too if you think that they wont be
# needed. When script detects entry without one of these keys and it needs it
# error will be raised, be aware that in this case some entries may still be
# written to the file, as there is currently no checking whether config is valid
# for specific statement
[4829/From: Someone] # Match receiving money from "Someone"
income=Income:Money Transferrevenue:money_transfer
payee=Someone
[4829/Someone] # Match sending money to "Someone"
outcome=Expenses:Money Transfer
payee=Someone
[4829/.*] # Match any other money transfer
income=Income:Money Transfer
outcome=Expenses:Money Transfer
[5499/Product Shop] # Match buying groceries at "Product Shop"
outcome=Expenses:Groceries
payee=Groceries
[6011/ATM.*] # Match withdrawing money from any ATM
outcome=Expenses:Money Withdraw
```
