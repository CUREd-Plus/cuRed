# NHS Metadata Dashboard

The Data Access Request Service (DARS) publishes an [NHS Metadata Dashboard](https://digital.nhs.uk/services/data-access-request-service-dars/dars-products-and-services/metadata-dashboard) which describes all the fields in the data sets that they publish. It is implemented as a Power BI dashboard which is hard to export data from, because it dynamically generates HTML code using code.

I've copy-pasted the relevant HTML code using the Chrome Developer Tools [Element DOM browser](https://developer.chrome.com/docs/devtools/dom). The metadata can be extracted from this using a HTML parser called [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/) in Python.

The output will be a CSV file containing the details of each field.

# Installation

1. Create a virtual environment (using [venv](https://docs.python.org/3/library/venv.html) or [Conda](https://conda.io/projects/conda/en/latest/index.html), etc.)
2. Install the required packages e.g. `pip install -r requirements.txt`

# Usage

## Get metadata

Follow these steps to download the HTML code for the DARS metadata.

1. Open the [NHS Metadata Dashboard](https://digital.nhs.uk/services/data-access-request-service-dars/dars-products-and-services/metadata-dashboard) in the Chrome browser.
2. Scroll the table down to the bottom to make all the rows appear. (The table will keep growing as you scroll down.)
3. Press F12 to open the [developer tools](https://developer.chrome.com/docs/devtools).
4. Select the "Elements" tab
5. Right-click on the `<html>` element and select copy &rightarrow; copy element.
6. Paste the data into an editor.
7. Save the file as a HTML file, such as `nhs_metadata.html`.

## Parse metadata

To view the usage instructions to run the script from the command line, run this command:

```bash
python -m nhs_metadata --help
```

To generate a metadata CSV

```bash
python -m nhs_metadata nhs_metadata.html
```

# Contributing

Please read the [Beautiful Soup Documentation](https://www.crummy.com/software/BeautifulSoup/bs4/doc/).
