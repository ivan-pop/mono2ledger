# mono2ledger
This is python script that I use to convert bank statement from
[monobank](https://monobank.ua/) to [ledger-cli](https://www.ledger-cli.org/)
entries.

## Usage:
First you will need to create/modify config file located at 
`$XDG_CONFIG_HOME/mono2ledger/config.ini` or
`~/.config/mono2ledger/config.ini` in which you will need to set
required script options and setup entry matchers, see below for
example config with option descriptions.

There are two modes of usage, one is using csv statement downloaded
using monobank app, and the other is using 
[monobank API](https://api.monobank.ua/). If using monobank API you
must provide API key using `MONOBANK_API_KEY` environment variable,
check out api documentation for info on how to obtain it.
In this mode mono2ledger will get the date of last ledger transaction
and automatically fetch statemens from that date. Be aware that using
API method you can only fetch statements that are one month old, if
you need statements for longer periods of time you will need to use
csv method, mono2ledger will notify you if that is the case.
Also note that API always returns results in ukrainian language, so
you might get some errors about missing config lines for statement
entries if you previously had used csv export in english language.

If using csv method just download csv statement from monobank app and
provide it as an argument to mono2ledger.

In both operation modes you can pass optional `--no-edit` or `-n` flag
to not modify ledger files in any way and just print possible output,
if there is any.

## Example config:
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

## Not implemented/TODO
- Handling of exchanges between currencies and any other currencies other than
  UAH. Script has some checks to prevert such entries from breaking parser and
  it will error out in case it finds such values
- Combining several operations on same day with same payees into single
  ledger entries. This should make output a bit prettier
- Allow fetching account name for API fetch method
- Specifying config file with command-line flag
- Better and more consistent error handling
- Maybe split to smaller more centered modules that can be used
  instead of using single file that becomes a bit hard to manage
