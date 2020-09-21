using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBV
{
    public partial class Login : Form
    {
        public static string username = "";
        public Login()
        {
            InitializeComponent();
            
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            DataProvider provider = new DataProvider(txtusername.Text, txtpassword.Text);
            try
            {
                provider.getConnect();
                if(provider.Connect.State == ConnectionState.Open)
                {
                    MessageBox.Show("Opened");
                    Login.username = txtusername.Text;       
                    Form1 form1 = new Form1(txtusername.Text, txtpassword.Text);
                    form1.Show();
                    this.Hide();
                }
                
            }
            catch (Exception err)
            {
                MessageBox.Show(err.ToString());
            }
            finally
            {
                provider.disConnect();
            }
            
        }

        private void btnExist_Click(object sender, EventArgs e)
        {
            Environment.Exit(0);
        }
    }
}


//try
//            {
//                db.getConnect();

//                string sql = "select * from benhvien." + txtTb.Text;

//OracleCommand cmd = new OracleCommand(sql, db.Connect);
//cmd.CommandType = CommandType.Text;
//                DataTable dt = new DataTable();
//                using (OracleDataAdapter dataAdapter = new OracleDataAdapter())
//                {
//                    dataAdapter.SelectCommand = cmd;
//                    dataAdapter.Fill(dt);
//                }
//                dataGridView1.DataSource = dt;

//            }
//            catch(Exception err)
//            {
//                MessageBox.Show(err.ToString());
//            }
//            finally
//            {
//                db.disConnect();
//            }
