# Load required libraries
library(shiny)
library(readr)
library(RDCOMClient)

# Define UI for app
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/suneditor@latest/dist/css/suneditor.min.css"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/suneditor@latest/dist/suneditor.min.js"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/suneditor@latest/src/lang/en.js"),
    tags$script(HTML("
      Shiny.addCustomMessageHandler('resetFileInput', function(variableName) {
        var control = $('#' + variableName + '_progress');
        control.replaceWith(control.clone().val(''));
        $('#' + variableName).val(null);
        $('#' + variableName + '_label').text('No file chosen');
        $('#' + variableName + '_name').text('');  // Clear file name text
        $('#' + variableName + '_progress').css('visibility', 'hidden');
        $('#' + variableName + '_name').css('visibility', 'hidden');  // Hide file name
      });

      Shiny.addCustomMessageHandler('initSunEditor', function(id) {
        var editor = SUNEDITOR.create(document.getElementById(id), {
          defaultStyle: 'font-family: Arial; font-size: 14px;',  // Set default font and size
          formats: ['p', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'pre'],  // Available formats
          buttonList: [
                ['undo', 'redo'],
                ['font', 'fontSize', 'formatBlock'],
                ['paragraphStyle', 'blockquote'],
                ['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
                ['fontColor', 'hiliteColor', 'textStyle'],
                ['removeFormat'],
                '/', // Line break
                ['outdent', 'indent'],
                ['align', 'horizontalRule', 'list', 'lineHeight'],
                ['table', 'link', 'image', 'video', 'audio'],
                ['fullScreen', 'showBlocks', 'codeView'],
                ['preview', 'print'],
                ['save', 'template'],
            ]
        });

        editor.onChange = function(contents, core) {
          Shiny.setInputValue(id + '_content', contents);
        };

        Shiny.setInputValue(id + '_content', editor.getContents());

        Shiny.addCustomMessageHandler('updateSunEditor', function(content) {
          editor.setContents(content);
        });
      });
    "))
  ),
  titlePanel("BatchMaileR v.2.1.0"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput('dataset', 'Upload Assessor Dataset (CSV)', accept = c('.csv')),
      fileInput('emailBodyFile', 'Upload Email Body (TXT)', accept = c('.txt')),
      textInput('emailSubject', 'Email Subject', placeholder = "Personalize by passing the arguments here."),
      textAreaInput('senderInfo', 'Sender Name and Title', rows = 2, placeholder = "Name\nTitle"),
      fileInput('attachments', 'Upload Common Attachments', multiple = TRUE),
      verbatimTextOutput('attachedFiles'),  # Display attached files
      checkboxInput('personalizedAttachments', 'Upload Personalized Attachments'),
      conditionalPanel(
        condition = "input.personalizedAttachments == true",
        textInput('attachmentDir', 'Directory Path', placeholder = "Format: /path/to/attachments"),
        textAreaInput('personalizedAttachmentNames', 'File names with extension (comma-separated)', rows = 2, placeholder = "Example: Image1_[AssessorID].png, Report_[AssessorID].pdf")
      ),
      actionButton('sendEmails', 'Send Emails'),
      actionButton('clearFields', 'Clear')
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Emailing",
                 tabsetPanel(
                   tabPanel("Data Preview", tableOutput('previewData')),
                   tabPanel("Edit Email Body", div(id = 'emailBody', style = 'height: 400px;'))
                 ),
                 verbatimTextOutput('status')
        ),
        tabPanel("User Guide",
                 h3("BatchMaileR v.2.1.0 - User Guide"),
                 h5("By Randy Frans Fela, PhD. | rffela@jabra.com | Perceptual Audio Evaluation Team | GN Audio A/S"),
                 h1("   "),
                 p("Welcome to BatchMaileR v.2.1.0! This application allows you to send batch emails with both common and personalized content and attachments."),
                 h4("1. Upload Dataset (CSV)"),
                 p("Click 'Browse' and select a CSV file containing recipient data. The first row should contain the column names, including AssessorEmail and other placeholders used in the email body or subject. The dataset will be loaded into the Data Preview tab."),
                 h4("2. Upload Email Body (TXT) (optional)"),
                 p("Click 'Browse' and select a TXT file containing the initial email body content. The content will be loaded into the rich text editor for further editing."),
                 h4("3. Email Subject"),
                 p("Enter the subject of the email. You can use placeholders in the format [ColumnName]."),
                 h4("4. Sender Name and Title"),
                 p("Enter the sender's name and title in two lines (e.g., 'John Doe\nCEO'). You should also put important information such as contact email and phone number."),
                 h4("5. Upload Common Attachments (optional)"),
                 p("Click 'Browse' and select one or more files to be attached to all emails."),
                 h4("6. Upload Personalized Attachments (optional)"),
                 p("Check the 'Upload Personalized Attachments' checkbox if you want to include attachments specific to each recipient."),
                 p("Enter the directory path where the personalized attachments are stored. Remember, use Forward Slash (/) for directory path."),
                 p("Enter the filenames with extensions in a comma-separated format. Use placeholders for dynamic filenames (e.g., 'Report_[AssessorID].pdf')."),
                 h4("7. Edit Email Body"),
                 p("Use the rich text editor to modify the email body. The editor supports various formatting options."),
                 h4("8. Send Emails"),
                 p("Click 'Send Emails' to start the email sending process. The status of the operation will be displayed below."),
                 h4("9. Clear Fields"),
                 p("Click 'Clear' to reset all fields and clear the application state.")
        )
      )
    )
  )
)