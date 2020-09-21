using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client; //Thư viện oracle client
using System.Configuration; //Để truy cập vào thuộc tính App.config 

namespace BaoMatAPP
{
    public partial class Form1 : Form
    {
        //Mở kết nối đến connectionString trong App.config mình vừa setup.
        OracleConnection con = new OracleConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString);
        
        public Form1()
        {
            InitializeComponent();
        }

  
        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                OracleCommand cmd = new OracleCommand($"SELECT owner, table_name  FROM dba_tables WHERE owner <> 'SYS' AND owner <> 'SYSTEM' AND owner <> 'OUTLN' AND owner <> 'DBSFWUSER' AND owner <> 'DBSNMP' AND owner <> 'APPQOSSYS' AND owner <> 'GSMADMIN_INTERNAL' AND owner <> 'XDB' AND owner <> 'WMSYS' AND owner <> 'OJVMSYS' AND owner <> 'CTXSYS' AND owner <> 'ORDDATA' AND owner <> 'MDSYS' AND owner <> 'ORDSYS' AND owner <> 'OLAPSYS' AND owner <> 'LBACSYS' AND owner <> 'DVSYS' AND owner <> 'AUDSYS' AND owner <> 'DVSYS'", con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dtg_DSTable.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }

            string sql = "";
           
           sql = "SELECT * FROM DBA_ROLES";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dtg__ROLE_USER.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
            String sql1 = "SELECT* FROM DBA_USERS order by created DESC";
            try
            {
                OracleCommand cmd = new OracleCommand(sql1, con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dtg__user.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
            label_column.Text = "";
            
            label_table.Text = "";
            cbb_table.Visible = false;
            cbb_Column.Visible = false;
           
            cbSelect.Visible = false;
            cbUpdate.Visible = false;
            cbInsert.Visible = false;
            cbDelete.Visible = false;

            cb__SELECT.Visible = false;
            cb__INSERT.Visible = false;
            cb__DELETE.Visible = false;
            cb__UPDATE.Visible = false;
            cb__WGO.Visible = false;

            bt_thuhoiquyen.Visible = false;
            bt_ChinhSuaquyen.Visible = false;
            bt_XacNhan.Visible = false;
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            string sql = "";
            if (cb__htQtrcot.Checked == true)
            {
                sql = $"select GRANTEE,OWNER,TABLE_NAME,COLUMN_NAME,PRIVILEGE,GRANTOR,GRANTABLE,COMMON,INHERITED from DBA_COL_PRIVS WHERE GRANTEE = '{txtUsername.Text}'";
            }
            else
            {
                sql = $"select * from dba_tab_privs  where grantee = '{txtUsername.Text}' ";
            }
            try
            {
                OracleCommand cmd = new OracleCommand(sql, con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dgvPri.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
        }

        private void btnShow_Click(object sender, EventArgs e)
        {
            string sql = "";
            if (cbb__usro.Text == "Role") {
                sql = "SELECT * FROM DBA_ROLES";
            }
            if (cbb__usro.Text == "User")
            {
                sql = "SELECT* FROM DBA_USERS order by created DESC";
            }
            if (cb__htQtrcot.Checked == true)
            {
                sql = "select * from DBA_COL_PRIVS WHERE GRANTEE <> 'IMP_FULL_DATABASE' ";
            }
            
            try
            {
                OracleCommand cmd = new OracleCommand(sql, con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dgvLoadUsers.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
                Them_User_Role add = new Them_User_Role();
                add.ShowDialog();
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
                Xoa_User_Role xoa = new Xoa_User_Role();
                xoa.ShowDialog();
            }

        private void btnFix_Click(object sender, EventArgs e)
        {
            Sua_User_Role sua = new Sua_User_Role();
            sua.ShowDialog();
        }

        private void label6_Click(object sender, EventArgs e)
        {
            if (cbCapQuyen.Text == "User")
            {
                label6.Text = "Username";

            } else label6.Text = "Role";
        }

       

        private void cbb_GrantIn_SelectedIndexChanged(object sender, EventArgs e)
        {
            label_table.Text = "TABLE";
            cbb_table.Visible = true;
            if (cbb_GrantIn.Text == "TABLE")
            {

                cbSelect.Visible = true;
                cbUpdate.Visible = true;
                cbInsert.Visible = true;
                cbDelete.Visible = true;
            }
            else
            {
                label_column.Text = "";
                cbb_Column.Visible = false;
            }
            if (cbb_GrantIn.Text == "COLUMN")
            {
                label_column.Text = "COLUMN";
                cbb_Column.Visible = true;

                cbSelect.Visible = false;
                cbUpdate.Visible = true;
                cbInsert.Visible = true;
                cbDelete.Visible = false;
            }
            else
            { 
                label_column.Text = "";
                cbb_Column.Visible = false;
            }
        
        }


        private void dtg_DSTable_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            String TenUser = dtg_DSTable.Rows[e.RowIndex].Cells[0].Value.ToString();
            String TenBang = dtg_DSTable.Rows[e.RowIndex].Cells[1].Value.ToString();
            cbb_table.Text = TenBang;
            label_user.Text = TenUser;
            try
            {
                OracleCommand cmd = new OracleCommand("select * from "+ TenUser + "."+ TenBang + " ", con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dtg_TableDetail.DataSource = dt;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
        }

        private void btnCapQuyen_Click(object sender, EventArgs e)
        {

            String select = "";
            String insert = "";
            String update = "";
            String delete = "";
            String Table = cbb_table.Text.ToString();
            String Column = "";
            
            String User = txt_User_role.Text.ToString();

            String Dauphay1 = "";
            String Dauphay2 = "";
            String Dauphay3 = "";
            String wgo = "";

            String owner = label_user.Text.ToString();

            if (cbb_Column.Text.ToString() != "")
            {
                Column = "(" + cbb_Column.Text.ToString() + ")";
            }
            if (cbSelect.Checked == true)
            {
                select = "SELECT" + Column;
            }
            if (cbInsert.Checked == true)
            {
                insert = "INSERT" + Column;
            }
            if (cbUpdate.Checked == true)
            {
                update = "UPDATE" + Column;
            }
            if (cbDelete.Checked == true)
            {
                delete = "DELETE" + Column;
            }
            if (cbWithgrand.Checked == true)
            {
                wgo = " WITH GRANT OPTION";
            }
            if (cbSelect.Checked == true && cbInsert.Checked == true)
            {
                Dauphay1 = ",";
            }
            if (cbInsert.Checked == true && cbUpdate.Checked == true)
            {
                Dauphay2 = ",";
            }
            if (cbUpdate.Checked == true && cbDelete.Checked == true)
            {
                Dauphay3 = ",";
            }
            if (cbSelect.Checked == true && cbUpdate.Checked == true || cbSelect.Checked == true && cbDelete.Checked == true)
            {
                Dauphay1 = ",";
            }
            if (cbInsert.Checked == true && cbDelete.Checked == true)
            {
                Dauphay2 = ",";
            }


            string SQL = "GRANT " + select + Dauphay1 + insert + Dauphay2 + update  + Dauphay3 + delete  + " on "+ owner + "."+ Table+" TO "+ User + wgo+" ";
      
            try
            {
                OracleCommand cmd1 = new OracleCommand("GRANT CREATE SESSION TO "+ User, con);
                OracleCommand cmd2 = new OracleCommand("ALTER SESSION SET \"_ORACLE_SCRIPT\" = TRUE", con);
                OracleCommand cmd3 = new OracleCommand(SQL, con);
                con.Open();
                cmd1.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                MessageBox.Show("Thành công!");
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }

        }

        String TenUser;
        String TenBang;
        String owner;
        String Pri;
        private void dgvPri_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            TenUser = dgvPri.Rows[e.RowIndex].Cells[0].Value.ToString();
            TenBang = dgvPri.Rows[e.RowIndex].Cells[2].Value.ToString();
            owner = dgvPri.Rows[e.RowIndex].Cells[1].Value.ToString();
            Pri = dgvPri.Rows[e.RowIndex].Cells[4].Value.ToString();
            bt_thuhoiquyen.Visible = true;
            bt_ChinhSuaquyen.Visible = true;
            dgvPri.Size = new System.Drawing.Size(778, 143);
            cb__SELECT.Visible = false;
            cb__INSERT.Visible = false;
            cb__DELETE.Visible = false;
            cb__UPDATE.Visible = false;
            cb__WGO.Visible = false;
            bt_XacNhan.Visible = false;
            bt_ChinhSuaquyen.BackColor = Color.White;
            bt_thuhoiquyen.BackColor = Color.White;
        }
        private void bt_thuhoiquyen_Click(object sender, EventArgs e)
        {
            bt_thuhoiquyen.BackColor = Color.Red;
            bt_ChinhSuaquyen.Visible = false;
            try
            {
               
                String sql = "REVOKE " + Pri + " ON " + owner + "." + TenBang + " FROM " + TenUser;
                String sqlcap = "GRANT " + Pri + " ON " + owner + "." + TenBang + " TO " + TenUser;
                OracleCommand cmd2 = new OracleCommand("ALTER SESSION SET \"_ORACLE_SCRIPT\" = TRUE", con);
                OracleCommand cmd3 = new OracleCommand(sql, con);
                OracleCommand cmd4 = new OracleCommand(sqlcap, con);
                con.Open();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                if (cb__htQtrcot.Checked == true) { cmd4.ExecuteNonQuery(); }
                MessageBox.Show("Thu hồi quyền Thành công!");
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
            bt_thuhoiquyen.BackColor = Color.White;
        }

        private void bt_ChinhSuaquyen_Click(object sender, EventArgs e)
        {
            bt_ChinhSuaquyen.BackColor = Color.Red;
            bt_thuhoiquyen.Visible = false;


            dgvPri.Size = new System.Drawing.Size(576, 143);
            cb__SELECT.Visible = true;
            cb__INSERT.Visible = true;
            cb__DELETE.Visible = true;
            cb__UPDATE.Visible = true;
            cb__WGO.Visible = true;
            bt_XacNhan.Visible = true;
        }

        private void bt_XacNhan_Click(object sender, EventArgs e)
        {
            String select = "";
            String insert = "";
            String update = "";
            String delete = "";    

            String Dauphay1 = "";
            String Dauphay2 = "";
            String Dauphay3 = "";
            String wgo = "";

            if (cb__SELECT.Checked == true)
            {
                select = "SELECT";
            }
            if (cb__INSERT.Checked == true)
            {
                insert = "INSERT";
            }
            if (cb__UPDATE.Checked == true)
            {
                update = "UPDATE";
            }
            if (cb__DELETE.Checked == true)
            {
                delete = "DELETE";
            }
            if (cb__WGO.Checked == true)
            {
                wgo = " WITH GRANT OPTION";
            }
            if (cb__SELECT.Checked == true && cb__INSERT.Checked == true)
            {
                Dauphay1 = ",";
            }
            if (cb__INSERT.Checked == true && cb__UPDATE.Checked == true)
            {
                Dauphay2 = ",";
            }
            if (cb__UPDATE.Checked == true && cb__DELETE.Checked == true)
            {
                Dauphay3 = ",";
            }
            if (cb__SELECT.Checked == true && cb__UPDATE.Checked == true || cb__SELECT.Checked == true && cb__DELETE.Checked == true)
            {
                Dauphay1 = ",";
            }
            if (cb__INSERT.Checked == true && cb__DELETE.Checked == true)
            {
                Dauphay2 = ",";
            }

            string SQL2 = "GRANT " + select + Dauphay1 + insert + Dauphay2 + update + Dauphay3 + delete + " on " + owner + "." + TenBang + " TO " + TenUser + wgo + " ";

            try
            {


                String sql1 = "REVOKE " + Pri + " ON " + owner + "." + TenBang + " FROM " + TenUser;
                OracleCommand cmd2 = new OracleCommand("ALTER SESSION SET \"_ORACLE_SCRIPT\" = TRUE", con);
                OracleCommand cmd3 = new OracleCommand(sql1, con);
                OracleCommand cmd4 = new OracleCommand(SQL2, con);
                con.Open();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                cmd4.ExecuteNonQuery();
                MessageBox.Show("Sửa quyền Thành công!");
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
            dgvPri.Size = new System.Drawing.Size(778, 143);
            cb__SELECT.Visible = false;
            cb__INSERT.Visible = false;
            cb__DELETE.Visible = false;
            cb__UPDATE.Visible = false;
            cb__WGO.Visible = false;
            bt_XacNhan.Visible = false;
            bt_ChinhSuaquyen.BackColor = Color.White;
        }

        private void cbCapQuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbCapQuyen.Text == "Role")
            {
                cbWithgrand.Visible = false;
            }
            if (cbCapQuyen.Text == "User")
            {
                cbWithgrand.Visible = true;
            }
        }


        String tenRole;
        String TenUser1;


        private void dtg__ROLE_USER_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

             tenRole = dtg__ROLE_USER.Rows[e.RowIndex].Cells[0].Value.ToString();
            tb__role.Text = tenRole;
        }

        private void dtg__user_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
             TenUser1 = dtg__user.Rows[e.RowIndex].Cells[0].Value.ToString();
            tb__user.Text = TenUser1;
        }
        private void bt_grantrole_Click(object sender, EventArgs e)
        {
            
            try
            {
                String role = tb__role.Text;
                String userg = tb__user.Text;
                String sqlcap = "GRANT " + role + " TO " + userg;
                OracleCommand cmd2 = new OracleCommand("ALTER SESSION SET \"_ORACLE_SCRIPT\" = TRUE", con);
                OracleCommand cmd4 = new OracleCommand(sqlcap, con);
                con.Open();
                cmd2.ExecuteNonQuery();   
                cmd4.ExecuteNonQuery();
                MessageBox.Show("Grant role Thành công!");
            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
        }

        private void bt__Reload_Click(object sender, EventArgs e)
        {
            try
            {
                OracleCommand cmd = new OracleCommand("SELECT * FROM DBA_ROLE_PRIVS  WHERE GRANTEE = '"+tb__user.Text+"' ", con);
                con.Open();
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                da.Dispose();

                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng, Thử Lại");
                }
                else
                {
                    dtg__RELOAD.DataSource = dt;
                }


            }
            catch (Exception)
            {
                MessageBox.Show("Lỗi!");
            }
            finally
            {
                con.Close();
            }
        }
    }
}
