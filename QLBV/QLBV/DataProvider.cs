using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;

namespace QLBV
{
    public partial class DataProvider
    {
        OracleConnection con { get; set; }
        private string username;
        private string password;

        public DataProvider()
        {
            this.username = "";
            this.password = "";
        }

        public DataProvider(string username, string password)
        {
            this.username = username;
            this.password = password;
        }

        public OracleConnection Connect
        {
            set { con = value; }
            get { return con; }
        }

        public string UserName
        {
            set { this.username = value; }
            get { return this.username; }
        }

        public string Password
        {
            set { this.password = value; }
            get { return this.password; }
        }

        public void getConnect()
        {
            string datasource = "localhost:1521/QUANLYBENHVIEN";
            string DBAPrivilege = "sysdba";
            
            string constring = @"Data Source=" + datasource + ";User ID=" + this.username + ";Password=" + this.password + ";";

            if(this.username.ToLower() == "sys")
            {
                constring += "DBA Privilege=" + DBAPrivilege + ";";
            }

            try
            {
                if(con == null)
                {
                    con = new OracleConnection(constring);
                    con.Open();
                }
                
                if(con.State != System.Data.ConnectionState.Open)
                {
                    con.Open();
                }
            }
            catch(Exception e)
            {
                throw e;
            }
        }

        public void disConnect()
        {
            try
            {
                if(con != null && con.State == System.Data.ConnectionState.Open)
                {
                    con.Close();
                }

            }catch(Exception e)
            {
                throw e;
            }
        }
    }
}
