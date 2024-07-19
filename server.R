# Load required libraries
library(shiny)
library(readr)
library(RDCOMClient)

# Define server logic
server <- function(input, output, session) {
  session$sendCustomMessage(type = 'initSunEditor', message = 'emailBody')
  
  # Reactive values to store uploaded data and status
  values <- reactiveValues(
    dataset = NULL,
    emailBodyFile = NULL,
    attachments = list(),
    status = "",
    attachedFiles = list()  # List to store attached file names
  )
  
  # Observe dataset upload
  observeEvent(input$dataset, {
    req(input$dataset)
    values$dataset <- read_csv(input$dataset$datapath)
    output$previewData <- renderTable({
      head(values$dataset)
    })
  })
  
  # Observe email body file upload
  observeEvent(input$emailBodyFile, {
    req(input$emailBodyFile)
    email_body_content <- readLines(input$emailBodyFile$datapath)
    email_body_content <- paste(email_body_content, collapse = "<br>")
    session$sendCustomMessage(type = 'updateSunEditor', message = email_body_content)
  })
  
  # Observe attachments upload
  observeEvent(input$attachments, {
    req(input$attachments)
    
    # Append new files to the existing list of attachments
    new_attachments <- lapply(seq_along(input$attachments$datapath), function(i) {
      list(
        name = input$attachments$name[i],
        datapath = input$attachments$datapath[i]
      )
    })
    
    values$attachments <- c(values$attachments, new_attachments)
    
    # Update list of attached files
    attached_files <- values$attachedFiles
    new_files <- lapply(input$attachments$name, function(name) {
      if (!is.null(name)) {
        basename(name)
      }
    })
    values$attachedFiles <- c(attached_files, new_files)
  })
  
  # Display list of attached files
  output$attachedFiles <- renderPrint({
    attached_files <- values$attachedFiles
    if (length(attached_files) > 0) {
      cat("Number of files attached: ", length(attached_files), "\n")
      cat("File names: ", paste(unlist(attached_files), collapse = ", "), "\n")
    } else {
      "No files attached."
    }
  })
  
  # Clear fields
  observeEvent(input$clearFields, {
    # Clear input values
    updateTextInput(session, 'emailSubject', value = "")
    updateTextAreaInput(session, 'senderInfo', value = "")
    updateTextInput(session, 'attachmentDir', value = "")
    updateTextAreaInput(session, 'personalizedAttachmentNames', value = "")
    session$sendCustomMessage(type = 'updateSunEditor', message = "")
    
    # Reset file inputs
    session$sendCustomMessage(type = 'resetFileInput', message = 'dataset')
    session$sendCustomMessage(type = 'resetFileInput', message = 'emailBodyFile')
    session$sendCustomMessage(type = 'resetFileInput', message = 'attachments')
    
    # Reset attached files display
    values$attachedFiles <- list()
    
    # Reset reactive values
    values$dataset <- NULL
    values$emailBodyFile <- NULL
    values$attachments <- list()
    values$status <- ""
    
    # Clear data preview
    output$previewData <- renderTable({ NULL })
  })
  
  # Send emails with error handling
  observeEvent(input$sendEmails, {
    req(values$dataset, input$emailBody_content, input$emailSubject, input$senderInfo)
    
    sender_info <- unlist(strsplit(input$senderInfo, "\n"))
    sender_name <- sender_info[1]
    sender_title <- sender_info[2]
    
    tryCatch({
      for (i in 1:nrow(values$dataset)) {
        assessor <- values$dataset[i, ]
        email_body <- input$emailBody_content
        email_subject <- input$emailSubject
        
        # Replace placeholders in email body and subject with corresponding values
        for (col_name in names(assessor)) {
          placeholder <- paste0("\\[", col_name, "\\]")
          email_body <- gsub(placeholder, assessor[[col_name]], email_body)
          email_subject <- gsub(placeholder, assessor[[col_name]], email_subject)
        }
        
        # Send email using RDCOMClient (Windows)
        OutApp <- COMCreate("Outlook.Application")
        outMail <- OutApp$CreateItem(0)
        outMail[["To"]] <- assessor$AssessorEmail
        outMail[["subject"]] <- email_subject
        outMail[["HTMLBody"]] <- paste0(email_body, "<br><br>", sender_name, "<br>", sender_title)
        
        # Attach common files
        if (length(values$attachments) > 0) {
          for (attachment in values$attachments) {
            temp_filepath <- file.path(tempdir(), attachment$name)
            file.copy(attachment$datapath, temp_filepath, overwrite = TRUE)
            outMail[["Attachments"]]$Add(temp_filepath)
          }
        }
        
        # Attach personalized files if activated
        if (input$personalizedAttachments) {
          personalized_dir <- input$attachmentDir
          personalized_files <- unlist(strsplit(input$personalizedAttachmentNames, "\\s*,\\s*"))
          
          for (filename in personalized_files) {
            # Replace placeholders in filename with dataset column values
            for (col_name in names(assessor)) {
              placeholder <- paste0("\\[", col_name, "\\]")
              filename <- gsub(placeholder, assessor[[col_name]], filename)
            }
            
            filepath <- file.path(personalized_dir, filename)
            if (file.exists(filepath)) {
              outMail[["Attachments"]]$Add(filepath)
            } else {
              values$status <- paste("Error: Personalized attachment not found -", filename)
              return()
            }
          }
        }
        
        outMail$Send()
        values$status <- paste(values$status, "Emails sent successfully to", assessor$AssessorEmail,"!\n")
      }
      
    }, error = function(e) {
      values$status <- paste("Error sending emails:", e$message)
    })
  })
  
  # Display status
  output$status <- renderText({
    values$status
  })
}