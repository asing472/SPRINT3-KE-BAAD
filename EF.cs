using Pecunia.Entities;
using Pecunia.Contracts.DALContracts;
using Pecunia.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Data.Entity.Core.Objects;

namespace Pecunia.DataAcessLayer
{
	
    /// <summary>
    /// Contains data access layer methods for creating, updating, deleting account from Regular Accounts collection.
    /// </summary>
    public class RegularAccountDAL : RegularAccountDALBase, IDisposable
    {

        /// <summary>
        /// Adds new account to Regular Accounts collection.
        /// </summary>
        /// <param name="newAccount">Contains the account details to be added.</param>
        /// <returns>Determinates whether the new account is added.</returns>
        public override bool CreateAccountDAL(RegularAccount newAccount)
        {
            using (TeamEEntities db = new TeamEEntities())
            {
                ObjectResult<CreateRegularAccount_Result>  CreateRegularAccount = db.CreateRegularAccount(newAccount.CustomerID, newAccount.AccountType, newAccount.Branch, newAccount.MinimumBalance, newAccount.InterestRate);
                var result = CreateRegularAccount.FirstOrDefault();

                int v = result.Column1;
                newAccount.AccountNo = result.Column2;
            }

            return true;
        }

        /// <summary>
        /// Gets all regular accounts from the collection.
        /// </summary>
        /// <returns>Returns list of all accounts.</returns>
        public override List<GetAllRegularAccounts_Result> GetAllAccountsDAL()
        {
         
            using (TeamEEntities db = new TeamEEntities())
            {
                List<GetAllRegularAccounts_Result> AllRegularAccounts = db.GetAllRegularAccounts().ToList();
                //List<RegularAccount> AllRegularAccounts = (from a in db.RegularAccounts select a).ToList();

                return AllRegularAccounts;
            }

              

        }



        /// <summary>
        /// Gets regular account based on AccountNo
        /// </summary>
        /// <param name="searchAccountNo">Contains the account no to search the account.</param>
        /// <returns>returns the object of RegularAccount Class.</returns>
        public override GetRegularAccountByAccountNo_Result GetAccountByAccountNoDAL(string searchAccountNo)
        {

            //existingAccount = new RegularAccount();

            using (TeamEEntities db = new TeamEEntities())
            {
                GetRegularAccountByAccountNo_Result existingAccount = db.GetRegularAccountByAccountNo(searchAccountNo).FirstOrDefault();
                return existingAccount;

            }

            
            
        }


        /// <summary>
        /// Gets list of regular accounts based on CustomerID
        /// </summary>
        /// <param name="searchCustomerID">Contains the Customer ID to search the accounts.</param>
        /// <returns>Returns the list of RegularAccount class objects where the Customer ID matches.</returns>
        public override List<GetRegularAccountsByCustomerID_Result> GetAccountsByCustomerIDDAL(Guid searchCustomerID)
        {
			
			using (TeamEEntities db = new TeamEEntities())
            {
			
				List<GetRegularAccountsByCustomerID_Result> RegularAccountsByCustomerID = db.GetRegularAccountsByCustomerID(searchCustomerID);

				return RegularAccountsByCustomerID;
            }
            
        }

        /// <summary>
        /// Gets list of regular accounts based on Account Type
        /// </summary>
        /// <param name="searchAccountType">Contains the type of regular account(Savings or Current) to search the accounts.</param>
        /// <returns>Returns the list of RegularAccount class objects.</returns>
        public override List<GetRegularAccountsByAccountType_Result> GetAccountsByTypeDAL(string searchAccountType)
        {
			using (TeamEEntities db = new TeamEEntities())
            {
				
				List<GetRegularAccountsByAccountType_Result> AccountsByType = db.GetRegularAccountsByAccountType(searchAccountType);
			
				return AccountsByType;
			}
            
        }

        /// <summary>
        /// Gets list of regular accounts based on branch
        /// </summary>
        /// <param name="searchBranch">Contains the account in a particular branch.</param>
        /// <returns>Returns the list of Regular Account class objects.</returns>
        public override List<GetRegularAccountsByBranch_Result> GetAccountsByBranchDAL(string searchBranch)
        {
			using (TeamEEntities db = new TeamEEntities())
            {
				
				List<GetRegularAccountsByBranch_Result> AccountsByBranch = db.GetRegularAccountsByBranch(searchBranch);

				return AccountsByBranch;
			}
        }

        /// <summary>
        /// Gets list of regular accounts based on range of dates
        /// </summary>
        /// <param name="startDate">Contains the starting date.</param>
        /// <param name="endDate">Contains the ending date.</param>
        /// <returns>Returns the list of RegularAccount class objects.</returns>
        public override List<GetRegularAccountsByAccountOpeningDate_Result> GetAccountsByAccountOpeningDateDAL(DateTime startDate, DateTime endDate)
        {
            List<RegularAccount> AccountsByDate = new List<RegularAccount>();
			using (TeamEEntities db = new TeamEEntities())
            {
				
				List<GetRegularAccountsByAccountOpeningDate_Result> AccountsByDate = db.GetRegularAccountsByBranch(searchBranch);

				return AccountsByDate;
			}
            
        }

        /// <summary>
        /// Gets Current Balance in the  regular account
        /// </summary>
        /// <param name="accountNumber">Contains the account number for which balance is requested.</param>
        /// <returns>Returns the current balance.</returns>
        public override double GetBalanceDAL(string accountNumber)
        {

            double balance = 0;

           
            return balance;
        }

        /// <summary>
        /// Updates the balance after every transaction
        /// </summary>
        /// <param name="accountNumber">Contains the account number.</param>
        /// <param name="balance">Contains the updated balance after a transaction .</param>
        /// <returns>Determines whether the account balance is updated or not.</returns>
        public override bool UpdateBalanceDAL(string accountNumber, double balance)
        {
            bool BalanceUpdated = false;

           
            return BalanceUpdated;
        }

        /// <summary>
        /// Updates the branch of a regular account
        /// </summary>
        /// <param name="accountNumber">Contains the account number of the account.</param>
        /// <returns>Determines whether the branch is updated or not.</returns>
        public override bool UpdateBranchDAL(RegularAccount updateAccount)
        {
            bool AccountBranchUpdated = false;

           
            return AccountBranchUpdated;
        }

        /// <summary>
        /// Updates the account type from savings to current or vice-versa
        /// </summary>
        /// <param name="accountNumber">Contains the account number of the account.</param>
        /// <param name="accountType">Contains the new account type of the account.</param>
        /// <returns>Determines whether the account type is updated or not.</returns>
        public override bool UpdateAccountTypeDAL(RegularAccount updateAccount)
        {
            bool AccountTypeUpdated = false;

            
            return AccountTypeUpdated;
        }

        /// <summary>
        /// Deletes an existing regular account
        /// </summary>
        /// <param name="deleteAccountNo">Contains the account number of the account to be deleted.</param>
        /// <returns>Determines whether the account is deleted or not.</returns>
        public override bool DeleteAccountDAL(string deleteAccountNo)
        {
            bool AccountDeleted = false;

            
            return AccountDeleted;

        }


        /// <summary>
        /// Clears unmanaged resources such as db connections or file streams.
        /// </summary>

        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}