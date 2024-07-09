# BatchMaileR v.1.0.0

## Overview

**BatchMaileR v.1.0.0** is a Shiny web application designed to simplify the process of sending batch emails with attachments. It allows users to upload a dataset containing email addresses and other relevant information, customize the email body and subject, and attach multiple files. The app ensures that each email is personalized by replacing placeholders in the email body and subject with corresponding values from the dataset.

## Features

- **Batch Email Sending**: Send personalized emails to multiple recipients based on data from a CSV file.
- **Email Body Customization**: Edit the email body directly within the app or upload a text file containing the email body.
- **Attachments**: Upload multiple attachments, either all at once or one by one, and ensure that original file names are preserved in the sent emails.
- **Email Preview**: Preview the dataset and email body before sending.
- **Reset Functionality**: Clear all fields and reset file inputs easily.

## Installation

### Prerequisites

- **R**: Make sure you have R installed on your system. You can download it from [CRAN](https://cran.r-project.org/).
- **RStudio**: It is recommended to use RStudio for running this application.

### Required Libraries

Install the required libraries by running the following commands in your R console:

```R
install.packages("shiny")
install.packages("readr")
install.packages("devtools")
devtools::install_github("omegahat/RDCOMClient")
```

## Usage

1. **Clone or Download the Repository**: Download the source code of BatchMaileR v.1.0.0 from the GitHub repository.
2. **Open the R Script**: Open the `app.R` file in RStudio.
3. **Run the Application**: Click on the "Run App" button in RStudio or use the following command in your R console:
   ```R
   shiny::runApp('path_to_app_directory')
   ```

## User Interface

### Sidebar Panel

- **Upload Assessor Dataset (CSV)**: Upload a CSV file containing the recipient data. The CSV should have a column named `AssessorEmail` for the email addresses and other columns for personalization.
- **Upload Email Body (TXT)**: Upload a text file containing the email body. Placeholders in the format `[ColumnName]` will be replaced with corresponding values from the dataset.
- **Email Subject**: Enter the email subject. Placeholders in the format `[ColumnName]` will be replaced with corresponding values from the dataset.
- **Sender Name and Title**: Enter the sender's name and title.
- **Upload Attachments**: Upload one or more attachments. You can upload multiple files at once or one by one. The app ensures original file names are preserved in the sent emails.
- **Send Emails**: Click this button to send the emails.
- **Clear**: Click this button to clear all fields and reset file inputs.

### Main Panel

- **Data Preview**: View the first few rows of the uploaded dataset.
- **Edit Email Body**: Edit the email body directly within the app.
- **Status**: View the status of email sending operations.

## Error Handling

If an error occurs during the email sending process, an error message will be displayed in the status section. Common issues might include missing required fields or incorrect file formats.

## Contribution

Feel free to fork this repository and submit pull requests. Contributions are welcome!

---

BatchMaileR v.1.0.0 - Making batch email sending simple and efficient!
