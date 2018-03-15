#EditedChallenge

This repository contains a small search trend engine used to visualize and understand the demand
of various moments in history to help us better understand the market.

#Approach

In order to minimize Reading/Loading of large files.
All the CSV files were converted to the efficient .RDS data format supported by R language.
The App is built using Shiny,Plotly,dplyr,etc.

#The Working Application

The Application contains three tabs:
1.Description - This tab allows you to type in words that are usually searched for in the description and visualize its distribution.
2.Product - Allows the user to understand the distribution  of search terms based on the brand/category of each item.
3.Filter - This tab is the highlight that allows users to send Start and end dates and filter out information lying between these dates.

#Things that could be improved.
1.Adding a better UI.
2.Customised graphs.
3.Faster Access.
