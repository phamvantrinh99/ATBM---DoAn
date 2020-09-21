using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBV
{
    public partial class DataModel
    {
        public DataModel() { }

        public int DocDuLieu(DataProvider provider, string query)
        {
            provider.getConnect();
            try
            {
                OracleCommand cmd = new OracleCommand($"{query}");
                cmd.Connection = provider.Connect;
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng");
                }
                else
                {
                    da.Dispose();
                    return dt.Rows.Count;
                }
                return 0;
            }
            catch (Exception err)
            {
                MessageBox.Show(err.ToString());
                return 0;
            }
            finally
            {
                provider.disConnect();
            }
        }

        public void DocDuLieu(DataProvider provider, string query, ComboBox cb, string display)
        {
            provider.getConnect();
            try
            {
                OracleCommand cmd = new OracleCommand($"{query}");
                cmd.Connection = provider.Connect;
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng");
                }
                else
                {
                    cb.DataSource = dt;
                    cb.DisplayMember = display;
                    da.Dispose();
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

        public void DocDuLieu(DataProvider provider, string query, DataGridView dgv)
        {
            provider.getConnect();
            try
            {
                OracleCommand cmd = new OracleCommand($"{query}");
                cmd.Connection = provider.Connect;
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                dt.Clear();
                da.Fill(dt);
                dgv.DataSource = null;
                if (dt.Rows.Count <= 0)
                {
                    MessageBox.Show("Rỗng");
                }
                else
                {
                    da.Dispose();
                    dgv.DataSource = dt;
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

        public bool InsertData(DataProvider provider, string query)
        {
            provider.getConnect();
            try
            {
                OracleCommand cmd = new OracleCommand(query);
                cmd.Connection = provider.Connect;
                int rowsUpdated = cmd.ExecuteNonQuery();
                if (rowsUpdated == 0)
                    MessageBox.Show("Record not inserted");
                else
                    MessageBox.Show("Success!");

                return true;
            }
            catch (Exception err)
            {
                MessageBox.Show(err.ToString());
                return false;
            }
            finally
            {
                provider.disConnect();
            }
        }
    }
}
