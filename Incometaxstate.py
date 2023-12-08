import pandas as pd 
import numpy as np 

# simple project to help user identify what they pay in income taxes based on state 

#load data
df = pd.read_csv("Book1.csv")
df = pd.DataFrame(df)
print(df.info)
# figure out mean % for tax bracket rates 
tax_bracket= [10,12,22,24,32,35]
tax_income= [0,11000,11001,44725,44726,95375,95376,182100,182101,231250,231251,578125,578126]

print(np.mean(tax_bracket),"\n",np.mean(tax_income))

# average tax % is 22% with the avg income as 175,781.23 so if income is higher then its the higher bracket if its lower then lower bracket
#this is for a single individual 

# first need to adjust the tax columns to be divided by 100 since they are all in percents 

df[['Low Tax(%)']]= df[['Low Tax(%)']].div(100)
df[['High Tax(%)']]= df[['High Tax(%)']].div(100)

print(df.columns)

# there now all that left is user input so we can create a function to do it 
print("Enter State ")
State = input()
print("Enter income")
salary = float(input())
# Find the state to get the values for tax whether its high or low 

def tax_func(state, income):
    # Check if the state exists in the DataFrame
    state_columns = df.columns.tolist()
    if 'State ' in state_columns : 
        if state in df['State '].values:
             index_state = df[df['State '] == state].iloc[0]  # Get the index of the state

           # Get the tax rates for the state
             low_tax_rate = index_state ['Low Tax(%)']
             high_tax_rate = index_state ['High Tax(%)']

             if income <= 175781.23:
                tax_paid_low = low_tax_rate * income
                if tax_paid_low == 0:
                    print("You do not have any income tax")
                else:
                    print("Here's how much you pay in taxes: ", tax_paid_low)
             else:
                 tax_paid_high = high_tax_rate * income
                 if tax_paid_high == 0:
                    print("You do not have any income tax")
                 else:
                    print("Here's how much you pay in taxes: ", tax_paid_high)
        else:
             print("Invalid state entered")
    else: 
             print("State Column not found ")
tax_func(State, salary)
