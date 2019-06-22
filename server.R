#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#m00

library(recharts)

#data_template
data_template <-ChinaGDP;
names(data_template) <-c("年份","省份","收入")
library(shiny)
library(shinydashboard)
library(readxl)
library(openxlsx);


getDataFromExcel <- function(file,sheet=1)
{
   res <- read_excel(file,sheet)
   return(res)
};

writeDataToExcel <- function (data,fileName,sheetName)
{
  
  #write.xlsx(x = data,file = fileName,sheetName = sheetName,row.names = FALSE,append = T,showNA = T);
  write.xlsx(x = data,file = fileName,)
  
};

 shinyServer(function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    messageData <- data.frame(from=c("m1","m2"),message=c("msg1","msg2"))
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })
    
    # This is equivalent to calling:
    #   dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "messages", .list = msgs)
  })
  output$progressBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  output$approvalBox <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  # Same as above, but with fill=TRUE
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  output$approvalBox2 <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow", fill = TRUE
    )
  })
  output$vprogressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$vcount, "%"), "Progress", icon = icon("list"),
      color = "purple"
    )
  })
     #GET THE INTIIAL DATA
    csvdata <- reactive({
      if (input$fileType =='Excel')
      {
        inFile <- input$fileExcel
        if (is.null(inFile))
          return(NULL)
        res <-openxlsx::read.xlsx(inFile$datapath,sheet=1,colNames=input$header)
      }
      if (input$fileType == 'CSV')
      {
        inFile <- input$file1
        
        if (is.null(inFile))
          return(NULL)
        
        res <-read.csv(inFile$datapath, header = input$header)    
      }
      res
       
    })
    
    #DEAL WITH THE DATA----
    chartData<-eventReactive(input$chartShow,{
      bb<-csvdata()
      cc  <-data.table::dcast(bb, 省份~., sum, value.var='收入')
      cc<-cc[,2]
      res <- list(a=bb,b=cc)
    })
    
    # DEAL WITH DATA STEP BY STEP
    #   source  --->render()                      :runtime:
    #   source  --->reactive()  -->render()       :runtime: one data multi componet
    #   source  --->reactive()    -->reactive()---->reactive-----observerEvent  (enent+Render)
    #                                              :precalculate   calc at once
    #   reactive---->reactive()----->eventReactive()-----render()
    #                                               :calcalted step by step:
    
    
    
    
    
    
  output$contents <- renderDataTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
   
    csvdata()
  },options = list(orderClasses = TRUE,
                  lengthMenu = c(5, 15,30,50,75,100), 
                  pageLength = 5))
  output$fileTemlate_download2 <- downloadHandler(filename = function() { 'dataTemplate.csv' },
                                                 content = function(file) {
                                                   write.csv(data_template, file,row.names = FALSE)
                                                 })
  output$fileTemlate_download1 <- downloadHandler(filename = function() { 'dataTemplate.xlsx' },
                                                  content = function(file) {
                                                    options("openxlsx.borderColour" = "#4F80BD") 
                                                    write.xlsx(data_template, file,colNames = TRUE, borders = "columns")
                                                  })
  
   #处理HTML报告下载信息----
   output$report_html <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.html",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report_html.Rmd")
      #tempReport <- file.path("/srv/shiny-server/demo/demo112", "www/report_html.Rmd")
      #tempReport
      
      file.copy("report_html.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(data1 = chartData()$a,data2 = chartData()$b,chartTitle = input$chartTitle)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  output$report_pdf <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.pdf",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report_pdf.Rmd")
      #tempReport <- file.path("/srv/shiny-server/demo/demo112", "www/report_html.Rmd")
      #tempReport
      
      file.copy("report_pdf.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(data1 = chartData()$a,data2 = chartData()$b,chartTitle = input$chartTitle)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  output$report_word <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.docx",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report_word.Rmd")
      #tempReport <- file.path("/srv/shiny-server/demo/demo112", "www/report_html.Rmd")
      #tempReport
      
      file.copy("report_word.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(data1 = chartData()$a,data2 = chartData()$b,chartTitle = input$chartTitle)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
    output$chinaMapDemo <- renderEChart({
      
      p<-echartr(chartData()$a, 省份, 收入, 年份, type="map_china") 
      p <-p  %>%  setDataRange(splitNumber=0, valueRange=range(chartData()$b), 
                               color=c('red','orange','yellow','limegreen','green')) 
      p <-p %>%    setTitle(input$chartTitle)
      
      print(p)
      
      
      
      
    })
    
  output$vapprovalBox <- renderValueBox({
    valueBox(
      "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  # output$userpanel <- renderUI({
  #   # session$user is non-NULL only in authenticated sessions
  #   if (!is.null(session$user)) {
  #     sidebarUserPanel(
  #       span("Logged in as ", session$user),
  #       subtitle = a(icon("sign-out"), "Logout", href="__logout__"))
  #   }
  # })
 }
)
