using System;

public class account
{
	private int accNum = 1;
	public string accountNum { get; private set; }
	public decimal balance { get;  set; }
	public DateTime openDate { get; private set; }


	public account ( string accountnum , decimal balance )
	{
		this.accountNum = Convert.ToString(accNum++);
		if ( balance >= 0 ) this.balance = balance;
		this.openDate = DateTime.Now;
	}

	public bool deposit(decimal amount)
	{
		if (amount > 0)
		{
			balance += amount;
			return true;
		}
		else
		{
			return false;
		}
	}

	public bool Withdraw(decimal amount)
	{
		if (amount > 0 && amount <= balance)
		{
			balance -= amount;
			return true;
		}
		else
		{
			return false;
		}
	}

	public bool transfer(decimal amount, account account2)
	{
		if ( Withdraw(amount))
		{
			account2.deposit(amount);
			return true;

		}
		return false;	
	}





}
