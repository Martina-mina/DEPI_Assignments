using System;

public class customer
{
	public static int nextCustomerId = 0;
	public string Name { get; set; }
	public string ID  { get; private set; }
	public string NationalId { get; set; }
	public DateTime dateOfBirth { get; set; }
	List<account> accounts { get; private set; }


	public customer(int id , string fullname  , DateTime birthdate)
	{
		if (String.IsNullOrEmpty(fullname) && String.IsNullOrEmpty(id))
		{
			this.Id = Convert.ToString(nextCustomerId++);
            this.Name = fullname;
			this.NationalId = nationalid;
			this.dateOfBirth = birthdate;
			this.accounts = new List<account>();
		}
		else
		{
			Console.WriteLine("please inter the data correctly ."
		}

	}

	public bool addAccount(account account1) 
	{
		if (account1 != null)
		{
			accounts.Add(account1);
			return true;
		}else 
		{ 
			return false;
		}
	}

    public decimal CalculateTotalBalance()
    {
        return this.Accounts.Sum(a => a.Balance);   //دي في حاله انه العميل عنده اكتر من حساب هو هيقوله اجمالي فلوسه قد اي   
    }



}
