using System;

public class savingAccount : Account
{

    public double InterestRate { get; private set; }

    public SavingAccount(decimal Balance, double interestRate) : base(Balance)
    {

        if (interestRate < 0)
        {
            Console.WriteLine("Interest rate mustn't be negative.");
        }
        else
        {
            this.InterestRate = interestRate;
        }

    }

    public void MonthlyInterest()
    {
        decimal interestAmount = this.Balance * (decimal)this.InterestRate;
        this.Deposit(interestAmount);
        Console.WriteLine("the monthly interest was added successfully .");
    }
}
