# BatchMaileR v2.1 - User Guide

## Introduction
Welcome to **BatchMaileR v2.1**! This application allows you to send batch emails with both common and personalized content and attachments. This guide will walk you through the setup and usage of the BatchMaileR application.

### Author
Randy Frans Fela, PhD. | Perceptual Audio Evaluation Team | GN Audio A/S

## Features
- Upload recipient data from a CSV file.
- Edit email body using a rich text editor with various formatting options.
- Personalize email content using placeholders.
- Attach common files to all emails.
- Optionally attach personalized files to each email.
- Clear fields and reset the application state easily.

## If you run this code from source

### Requirements
- Shiny library
- readr library
- RDCOMClient library (for Windows users)

### Installation
To use this application, ensure you have R and the required libraries installed. Install the necessary libraries using the following commands:
```R
install.packages("shiny")
install.packages("readr")
install.packages("RDCOMClient")
```

### Usage

1. **Clone or Download the Repository**: Download the source code of BatchMaileR v.1.0.0 from the GitHub repository.
2. **Open the R Script**: Open the `app.R` file in RStudio.
3. **Run the Application**: Click on the "Run App" button in RStudio or use the following command in your R console:
   ```R
   shiny::runApp('path_to_app_directory')
   ```

## How to Use BatchMaileR

### 1. Upload Assessor Dataset (CSV)
Click `Browse` and select a CSV file containing recipient data. The first row should contain the column names, including `AssessorEmail` and other placeholders used in the email body or subject.

### 2. Upload Email Body (TXT)
Click `Browse` and select a TXT file containing the initial email body content. The content will be loaded into the rich text editor for further editing.

### 3. Email Subject
Enter the subject of the email. You can use placeholders in the format `[ColumnName]`.

### 4. Sender Name and Title
Enter the sender's name and title in two lines (e.g., `John Doe\nCEO`).

### 5. Upload Common Attachments
Click `Browse` and select one or more files to be attached to all emails.

### 6. Upload Personalized Attachments (Optional)
Check the `Upload Personalized Attachments` checkbox if you want to include attachments specific to each recipient. Enter the directory path where the personalized attachments are stored. Enter the filenames with extensions in a comma-separated format. Use placeholders for dynamic filenames (e.g., `Report_[AssessorID].pdf`).

### 7. Edit Email Body
Use the rich text editor to modify the email body. The editor supports various formatting options.

### 8. Send Emails
Click `Send Emails` to start the email sending process. The status of the operation will be displayed below.

### 9. Clear Fields
Click `Clear` to reset all fields and clear the application state.

## Application UI

### Main Panel
- **Emailing Tab**:
  - **Data Preview**: Shows a preview of the uploaded recipient data.
  - **Edit Email Body**: Provides a rich text editor for editing the email body.
  - **Status**: Displays the status of the email sending process.

- **User Guide Tab**: Provides detailed instructions on how to use the application.

### Sidebar Panel
- **Upload Assessor Dataset (CSV)**: File input for uploading recipient data.
- **Upload Email Body (TXT)**: File input for uploading the initial email body content.
- **Email Subject**: Text input for the email subject.
- **Sender Name and Title**: Text area input for the sender's name and title.
- **Upload Common Attachments**: File input for uploading common attachments.
- **Attached Files**: Displays a list of uploaded attachments.
- **Upload Personalized Attachments**: Checkbox to enable personalized attachments.
- **Directory Path**: Text input for the directory path of personalized attachments.
- **File names with extension**: Text area input for the filenames of personalized attachments.
- **Send Emails**: Button to send the emails.
- **Clear**: Button to reset all fields and clear the application state.

## Contact
For any issues or questions, please contact Randy Frans Fela at [rffela@jabra.com](mailto:rffela@jabra.com).

---
