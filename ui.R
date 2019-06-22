#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# m00

library(shiny)
library(shinydashboard)
library(recharts)
# 1.01 add the 1st msg notification Menu----
headerMsg1<-  dropdownMenu(type = "messages",
                           messageItem(
                             from = "Sales Dept",
                             message = "Sales are steady this month."
                           ),
                           messageItem(
                             from = "New User",
                             message = "How do I register?",
                             icon = icon("question"),
                             time = "13:45"
                           ),
                           messageItem(
                             from = "Support",
                             message = "The new server is ready.",
                             icon = icon("life-ring"),
                             time = "2014-12-01"
                           )
);

# 1.02 add the dynamic menu ----

dynamicMsgMenu <-dropdownMenuOutput("messageMenu")

# 1.03 Notification Menu ----

NotiMenuObj <-dropdownMenu(type = "notifications",
                           notificationItem(
                             text = "5 new users today",
                             icon("users")
                           ),
                           notificationItem(
                             text = "12 items delivered",
                             icon("truck"),
                             status = "success"
                           ),
                           notificationItem(
                             text = "Server load at 86%",
                             icon = icon("exclamation-triangle"),
                             status = "warning"
                           ),
                           notificationItem(
                             text = "primary",
                             icon = icon("truck"),
                             status = "primary"),
                           notificationItem(
                             text = "here is your information to be noticed!",
                             icon = icon("truck"),
                             status = "info"),
                           notificationItem(
                             text = "look out ! be carefull!",
                             icon = icon("truck"),
                             status = "danger")
                           
)
# 1.04 task menu bar ----
taskMenuObj <- dropdownMenu(type = "tasks", badgeStatus = "success",
                            taskItem(value = 90, color = "green",
                                     "Documentation"
                            ),
                            taskItem(value = 70, color = "aqua",
                                     "Project X"
                            ),
                            taskItem(value = 75, color = "yellow",
                                     "Server deployment"
                            ),
                            taskItem(value = 80, color = "red",
                                     "Overall project"
                            )
)
#drill menu----




shinyUI(dashboardPage(skin = "blue",
                    
                    # add the themes selector
                    
                    #ui.header ----
                    
                    dashboardHeader(title = "ReshapeDataValue",
                                                                       taskMenuObj,
                                    headerMsg1,
                                    dynamicMsgMenu,
                                    NotiMenuObj,
                                    disable = F
                    ),
                    
                    #ui.sideBar----
                    dashboardSidebar(
                        sidebarMenu(
                        # add the item
                       
                        menuItem(text = "主题演示",tabName = "rdCostingTopic",icon=icon("cny")),
                        #menuItem(text = "**主题",tabName = "rdSalesTopic",icon=icon("diamond")),
                        #menuItem(text = "**主题",tabName = "rdForecastTopic",icon=icon("hand-o-right")),
                        #menuItem(text = "**主题",tabName = "rdBudgetTopic",icon=icon("bank")),
                        #menuItem("**主题", icon = icon("life-ring"), tabName = "rdScheduling",
                         #        badgeLabel = "new", badgeColor = "green"),
                        #menuItem(text = "**主题",tabName = "rdProfitTopic",icon=icon("bar-chart")),
                        menuItem(text = "基础资料",tabName = "rdMasterData",icon=icon("cubes"),
                                 sidebarMenu(
                                   menuItem(text="日期维度",tabName = "mdDateTime",icon = icon("cubes")),
                                   menuItem(text="地理纬度",tabName = "mdMapInfo",icon = icon("cubes")))),
                        menuItem(text = "系统设置",tabName = "rdSysSetting",icon=icon("cog"))
                        #,
                        #menuItem("棱星日志", icon = icon("file-code-o"), 
                         #        href = "http://blog.takewiki.com/",newtab =FALSE)
                        
                        
                      )
                    ),
                    
                    #ui.body----
                    dashboardBody(
                      tabItems(
                        # First tab content
                        
                        tabItem(tabName = "rdCostingTopic",
                                tabsetPanel(
                                  
                                  tabPanel("上传数据", 
                                           fluidRow(
                                             box(title = "选择数据源",width = 5, status = "primary",
                                                 radioButtons("fileType","文件类型",choices = c("Excel","CSV"),selected = "Excel"),
                                                 conditionalPanel("input.fileType =='Excel'",
                                                                  fileInput("fileExcel", "请选择一下Excel文件.",buttonLabel = "浏览",
                                                                            accept = c(
                                                                              ".xls",
                                                                              ".xlsx")
                                                                  ),
                                                                  
                                                                  checkboxInput("firstUse1","首次使用，请下载文件模板"),
                                                                  tags$hr(),
                                                                  conditionalPanel("input.firstUse1 == true",
                                                                                   downloadButton("fileTemlate_download1","下载文件模板"),tags$hr())),
                                                 conditionalPanel("input.fileType == 'CSV'",
                                                                  fileInput("file1", "请选择一下CSV文件.",buttonLabel = "浏览",
                                                                            accept = c(
                                                                              "text/csv",
                                                                              "text/comma-separated-values,text/plain",
                                                                              ".csv")
                                                                  ), checkboxInput("firstUse2","首次使用，请下载文件模板"),
                                                                  tags$hr(),
                                                                  conditionalPanel("input.firstUse2 == true",
                                                                                   downloadButton("fileTemlate_download2","下载文件模板"),tags$hr())),
                                                 
                                                                                                 #tags$hr(),
                                                 checkboxInput("header", "首行包含标题?", TRUE)
                                      
                                                 ),
                                             box(title = "预览数据集",width = 7, status = "primary",
                                                 dataTableOutput("contents"))
                                                                                        )
                                          
                                           
                                  ),
                                  tabPanel("数据分析", 
                                           fluidRow(
                                             box(title = "图表选项",width = 4, status = "primary",
                                                 textInput(inputId="chartTitle","设置图表标题"),
                                                 tags$hr(),
                                                 actionButton("chartShow","制图",icon = icon("bar-chart"))),
                                             box(title = "图表展示",width = 8, status = "primary",
                                                 eChartOutput("chinaMapDemo",height = "450px"))
                                            
                                           )),
                                  tabPanel("数据下载", fluidRow(
                                    box(title = "html",width = 4, status = "primary",
                                        downloadButton("report_html", "下载HTML格式分析报告")),
                                    box(title = "pdf",width = 4, status = "primary",
                                        downloadButton("report_pdf", "下载PDF格式分析报告")),
                                    box(title = "word",width = 4, status = "primary",
                                        downloadButton("report_word", "下载Word格式分析报告"))
                                    
                                  ))
                                  # ,
                                  # tabPanel("tab4", "Tab content 4"),
                                  # tabPanel("Tab5", "Tab content 5"),
                                  # tabPanel("Tab6", "Tab content 6"),
                                  # tabPanel("Tab7", "Tab content 7"),
                                  # tabPanel("Tab8", "Tab content 8")
                                )
                                )  ,
                        #top 2----
                        tabItem(tabName = "rdSalesTopic",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "rdSalesTopic",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        )  ,
                        
                        #topic 3----
                        tabItem(tabName = "rdForecastTopic",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "rdForecastTopic",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        ),
                        #topic 4----
                        tabItem(tabName = "rdBudgetTopic",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "rdBudgetTopic",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        ),
                        
                        #topic 5------
                              tabItem(tabName = "rdScheduling",
                                        tabsetPanel(
                                          
                                          tabPanel("Tab1", 
                                                   fluidRow(
                                                     box(title = "rdScheduling",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                                     box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                                     box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                                   ),
                                                   fluidRow(
                                                     box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                                     box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                                     box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                                   ),
                                                   fluidRow(
                                                     box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                                     box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                                     box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                                     
                                                   )
                                          ),
                                          
                                          tabPanel("Tab2", "Tab content 2"),
                                          tabPanel("Tab3", "Tab content 3"),
                                          tabPanel("Tab4", "Tab content 4"),
                                          tabPanel("Tab5", "Tab content 5"),
                                          tabPanel("Tab6", "Tab content 6"),
                                          tabPanel("Tab7", "Tab content 7"),
                                          tabPanel("Tab8", "Tab content 8")
                                        )
                                )
                                
                          ,
                        # topic 6-----
                        tabItem(tabName = "rdProfitTopic",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "rdProfitTopic",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        ),
                        #top 7----
                        
                        tabItem(tabName = "mdDateTime",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "mdDateTime",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        ),
                        
                        # topic 08 map------
                        tabItem(tabName = "mdMapInfo",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "mdMapInfo",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        ),
                        #top 09----
                        tabItem(tabName = "rdSysSetting",
                                tabsetPanel(
                                  
                                  tabPanel("Tab1", 
                                           fluidRow(
                                             box(title = "rdSysSetting",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                                             box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                                             box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                                             box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                                             box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                                           ),
                                           fluidRow(
                                             box(title = "tab1_31",width = 4, status = "primary",textInput(inputId="tab1_31","tab1layout31")),
                                             box(title = "tab1_32",width = 4, status = "primary",textInput(inputId="tab1_32","tab1layout32")),
                                             box(title = "tab1_33",width = 4, status = "primary",textInput(inputId="tab1_33","tab1layout33"))
                                             
                                           )
                                  ),
                                  
                                  tabPanel("Tab2", "Tab content 2"),
                                  tabPanel("Tab3", "Tab content 3"),
                                  tabPanel("Tab4", "Tab content 4"),
                                  tabPanel("Tab5", "Tab content 5"),
                                  tabPanel("Tab6", "Tab content 6"),
                                  tabPanel("Tab7", "Tab content 7"),
                                  tabPanel("Tab8", "Tab content 8")
                                )
                        )
                         
                        
                        
                      )
                    )
)
)


