using System;


public class CurrentAccount : Account
{
    public decimal OverdraftLimit { get; private set; }

    public CurrentAccount(decimal Balance, decimal overdraftLimit) : base(Balance)
    {
        if (overdraftLimit < 0)
        {
            Console.WriteLine("Overdraft limit cannot be negative.");
        }

        this.OverdraftLimit = overdraftLimit;
    }

    public override bool Withdraw(decimal amount)
    {
        if (amount <= 0)
        {
            return false;
        }else if (this.Balance - amount < - this.OverdraftLimit)
        {
            return false;
        }
        else
        {
            this.Balance -= amount;
            return true;
        }
        
    }
}


