using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    public static void Main(string[] args)
    {
        
        bank myBank = new bank("CIB Bank", "NB123");
       
        customer customer1 = new customer( '4000', "martina ",  new DateTime(2000 , 7, 18));
        myBank.addCustomer(customer1);
        savingAccount savingAcc = new savingAccount(5000, 0.05); 
        CurrentAccount currentAcc = new CurrentAccount(5000, 1000); 
        customer1.addAccount(savingAcc);
        customer1.addAccount(currentAcc);

       
        customer customer2 = new customer( '4001', "Mona", new DateTime(1995, 1, 20));
        myBank.addCustomer(customer2);
        customer2.addAccount(new savingAccount(10000, 0.04));

        decimal totalBalance = customer1.CalculateTotalBalance();
        savingAcc.MonthlyInterest();
        savingAcc.deposit(500);
        savingAcc.withdraw(100);

        
    }
}
