using System;

public class bank
{
    public string name { get; private set; } //برايفت هنا علشان مش اي حد يكتب اي اسم و اي رقم من عنده  
    public string branchNum { get; private set; }
    List<customer> customers { get;  set; }//هنا هعمل ليست للعملاء لان في عملاء عندهم اكتر من اكونت 


    public bank (string name , string branchNum)
	{
		if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(branchNum))
		{
			Console.WriteLine("name and branch code mustn't be empty or null" ); 
		}
		else
		{
			this.name = name;
			this.branchNum = branchNum;
			this.customers = new List<customer>();// null هنا هقوله ان الليست دي هتبقي في المكان الفلاني يعني هحط ريفرينس بدل م يبقي العنوان نفسه ب 

        }
	}

	public bool addCustomer(customer customer1)
	{
		if (customer1 == null)
		{
			return false;
		}
		else if (this.customers.Any(c => c.NationalId == customer1.NationalId))
		{
			return false; // دا معناه ان العميل دا موجود بالفعل 
		}
		else
		{
			this.customers.Add(customer1);
			return true;
		}
	}

	public customer findCustomer (string nationalId) {
		if (string.IsNullOrEmpty(nationalId))
		{
			Console.WriteLine("nationalId mustn't be null or empty ");
			return null;
		}
		else 
		{
		  return  this.customers.FirstOrDefault(c => c.NationalId == nationalId); // هيرجع اول عميل ال id بتاعه كدا 
        }
	}

	public bool updateCustomer(string NationalId, string name)
	{
	 customer updatedCustomer=findCustomer(NationalId); // اوبجيكت جديد فيه الاوبجيكت اللي هعدل عليه 
		if (updatedCustomer == null)
		{
			return false;
		}
		else
		{
			updatedCustomer.Name = name;
			return true;
		}
	}


    public bool removeCustomer(string NationalId, string name)
    {
        customer removedCustomer = findCustomer(NationalId); // اوبجيكت جديد فيه الاوبجيكت اللي هحذفه  
        if (removedCustomer == null)
        {
            return false;
        }
        else
        {
            this.customers.Remove(removedCustomer);
            return true;
        }
    }




}
