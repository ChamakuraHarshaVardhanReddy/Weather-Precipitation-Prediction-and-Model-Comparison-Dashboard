#LOAD AND INSPECT DATA
weather_data <- read.csv("H:/sem 5/predictive analysis/PREDICTIVEPROJECT12212300/weatherHistory.csv")
str(weather_data)
View(weather_data)

#PREPROCESSING AND CLEANING THE DATA
weather_data <- weather_data[, c("Precip.Type","Temperature..C.",
                                 "Humidity","Wind.Speed..km.h.")]
weather_data$Precip.Type[weather_data$Precip.Type == "null"] <- "Sunny"
View(weather_data)
sum(duplicated(weather_data))
weather_data <- weather_data[!duplicated(weather_data),]
sum(duplicated(weather_data))
weather_data <- na.omit(weather_data)
cleaned_data <- weather_data
table(cleaned_data$Precip.Type)

#NORMALIZING THE DATA USING SCALE FUNCTION
cleaned_data$Temperature..C. <- scale(cleaned_data$Temperature..C.)
cleaned_data$Humidity <- scale(cleaned_data$Humidity)
cleaned_data$Wind.Speed..km.h. <- scale(cleaned_data$Wind.Speed..km.h.)
cleaned_data$Precip.Type <- as.factor(cleaned_data$Precip.Type)

#PARTITION OF DATA
library(caret)
index <- createDataPartition(cleaned_data$Precip.Type, p =0.8,list = FALSE)
training_set <- cleaned_data[index,]
testing_set <- cleaned_data[-index,]

training_labels <- cleaned_data[index,"Precip.Type"]
testing_labels <- cleaned_data[-index,"Precip.Type"]

#EVALUATION OF DATA USING KNN ALGORITHM
library(class)
knn_model <-  knn(training_set[-1],testing_set[-1],cl = training_labels, k= 3)
confus_mat <- confusionMatrix(knn_model, testing_labels)
print(confus_mat)

#EVALUATION OF DATA USING NAIVE BAYES ALGORITHM
library(e1071)
naive_bayes <- naiveBayes(Precip.Type ~ ., data = training_set)
prediction <- predict(naive_bayes,testing_set)
confus_mat1 <- confusionMatrix(prediction, testing_labels)
print(confus_mat1)

#EVALUATING DATA USING DECISION TREE ALGORITHM
library(rpart)
library(rpart.plot)
library(caret)
decision_tree <- rpart(Precip.Type ~ ., data = training_set, method = "class")
rpart.plot(decision_tree)
prediction1 <- predict(decision_tree, testing_set, type = "class")
confus_mat2 <- confusionMatrix(prediction1, testing_labels)
print(confus_mat2)

#EVALUATING DATA USING SUPPORT VECTOR MACHINE ALGORITHM
library(e1071)
library(caret)
svm_model <- svm(Precip.Type ~ ., data = training_set, kernel = "linear")
prediction2 <- predict(svm_model, testing_set)
confus_mat3 <- confusionMatrix(prediction2, testing_labels)
print(confus_mat3)

#COMPARISION OF ALL THE ALGORITHMS 
knn_accuracy <- confus_mat$overall["Accuracy"]
nb_accuracy <- confus_mat1$overall["Accuracy"]
dt_accuracy <- confus_mat2$overall["Accuracy"]
svm_accuracy <- confus_mat3$overall["Accuracy"]

cat("--------MODEL ACCURACY--------\n")
cat("KNN ACCURACY : ", round(knn_accuracy *100,2),"%\n")
cat("NAIVE BAYES ACCURACY : ", round(nb_accuracy *100,2),"%\n")
cat("DECISION TREE ACCURACY : ",round(dt_accuracy *100,2),"%\n")
cat("SUPPORT VECTOR MACHINE ACCURACY : ",round(svm_accuracy *100,2),"%\n")

cat("------KNN PREDICTIONS------")
print(table(knn_model,testing_labels))

cat("------NAIVE BAYES PREDICTIONS------")
print(table(prediction,testing_labels))

cat("------DECISION TREE PREDICTIONS------")
print(table(prediction1,testing_labels))

cat("------SUPPORT VECTOR MACHINE PREDICTIONS------")
print(table(prediction2,testing_labels))

#VISUALIZING BOTH PREDICTIONS AND ACCURACY OF ALL ALGORTIHMS
#BAR PLOT OF COMPARING ACCURACY OF ALL THE ALGORITHMS
library("ggplot2")
accuracy_df <- data.frame(
  Model = c("KNN", "Naive Bayes", "Decision Tree", "SVM"),
  Accuracy = c(knn_accuracy * 100, nb_accuracy * 100, dt_accuracy * 100, svm_accuracy * 100)
)
accuracy_comparison_plot <- ggplot(accuracy_df, aes(x = Model, y = Accuracy, fill = Model)) +
  geom_bar(stat = "identity", width = 0.6) +
  ylim(0, 100) +
  labs(title = "Model Accuracy Comparison", y = "Accuracy (%)", x = "Model") +
  theme_minimal() +
  scale_fill_manual(values = c("KNN" = "cyan", "Naive Bayes" = "orange",
                               "Decision Tree" = "pink", "SVM" = "green"))+
  geom_text(aes(label = round(Accuracy, 2)),vjust = -0.5)
print(accuracy_comparison_plot)

#COMPARISION TABLE OF PREDICTED AND ACTUAL PRECIPITATION TYPE
knn_table <- as.data.frame(table(Predicted = knn_model,Actual =testing_labels))
nb_table <- as.data.frame(table(Predicted = prediction,Actual =testing_labels))
dt_table <- as.data.frame(table(Predicted = prediction1,Actual = testing_labels))
svm_table <- as.data.frame(table(Predicted = prediction2,Actual = testing_labels))
print(knn_table)
print(nb_table)
print(dt_table)
print(svm_table)

#KNN ALGORITHM CONFUSION MATRIX PLOT
knn_confMatrix <- ggplot(knn_table, aes(x = Actual, y = Predicted, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black") +
  scale_fill_gradient(low = "white", high = "cyan") +
  labs(title = "KNN Confusion Matrix", x = "Actual", y = "Predicted")
print(knn_confMatrix)

#NAIVE BAYES CONFUSION MATRIX PLOT
nb_confMatrix <- ggplot(nb_table, aes(x = Actual, y = Predicted, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black") +
  scale_fill_gradient(low = "white", high = "orange") +
  labs(title = "Naive Bayes Confusion Matrix", x = "Actual", y = "Predicted")
print(nb_confMatrix)

#DECISION TREE CONFUSION MATRIX PLOT
dt_confMatrix <- ggplot(dt_table,aes(x=Actual, y = Predicted, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black") +
  scale_fill_gradient(low = "white", high = "pink") +
  labs(title = "Decision Tree Confusion Matrix", x = "Actual", y = "Predicted")
print(dt_confMatrix)

#SUPPORT VECTOR MACHINE CONFUSION MATRIX PLOT
svm_confMatrix <- ggplot(svm_table, aes(x = Actual, y = Predicted, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black") +
  scale_fill_gradient(low = "white", high = "green") +
  labs(title = "Support Vector Machine Confusion Matrix", x = "Actual", y = "Predicted")
print(svm_confMatrix)

# Define UI for the Shiny dashboard
library(shiny)
ui <- fluidPage(
  titlePanel("Weather Precipitation Predictor"),
  sidebarLayout(
    sidebarPanel(
      h3("Model Comparison and Metrics"),
      p("This dashboard displays the accuracy comparison and confusion matrices for predicting the weather based on Temparature,Humidity and Wind Speed by using these four predictive models."),
      p("K Nearest Neighbour Algorithm"),
      p("Naive Bayes Algorithm"),
      p("Decision Tree Algorithm"),
      p("Support Vector Machine Algorithm")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Accuracy Comparison", plotOutput("accuracyPlot")),
        tabPanel("KNN Confusion Matrix", plotOutput("knnConfMatrix")),
        tabPanel("Naive Bayes Confusion Matrix", plotOutput("nbConfMatrix")),
        tabPanel("Decision Tree Confusion Matrix", plotOutput("dtConfMatrix")),
        tabPanel("SVM Confusion Matrix", plotOutput("svmConfMatrix"))
      )
    )
  )
)
server <- function(input, output) {
  output$accuracyPlot <- renderPlot({
    print(accuracy_comparison_plot)  
  })
  
  output$knnConfMatrix <- renderPlot({
    print(knn_confMatrix)  
  })
  
  output$nbConfMatrix <- renderPlot({
    print(nb_confMatrix)  
  })
  
  output$dtConfMatrix <- renderPlot({
    print(dt_confMatrix)  
  })
  
  output$svmConfMatrix <- renderPlot({
    print(svm_confMatrix)  
  })
}

shinyApp(ui = ui, server = server)

