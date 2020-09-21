using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLBV
{
    public partial class Form1 : Form
    {
        private string username;
        private string password;
        private DataProvider provider;
        public Form1(string username, string password)
        {
            InitializeComponent();
            this.username = username;
            this.password = password;
            txtUsername.Text = Login.username;
            provider = new DataProvider(this.username, this.password);
        }
        
        public static string formatDate(DateTimePicker date)
        {
            date.Format = DateTimePickerFormat.Custom;
            date.CustomFormat = "yyyy/MM/dd";
            return date.Text;
        }

        private void btnExist_Click(object sender, EventArgs e)
        {
            provider.disConnect();
            Environment.Exit(0);
        }
        

        private void btnXemDSNV_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.nhanvien", dgvNhanVien);
        }

        private void btnXemCaTruc_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.truc", dgvCaTruc);
        }

        private void btnThenNV_Click(object sender, EventArgs e)
        {

            ThemNhanVien formthennv = new ThemNhanVien(provider);
            formthennv.Show();
            
        }

        private void btnXemDV_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.DichVuKham", dgvDVKham);
        }

        private void btnXemThuoc_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.Thuoc", dgvThuoc);
        }

        private void btnThemDV_Click(object sender, EventArgs e)
        {
            int d = (int)System.DateTime.Now.DayOfWeek;
            string MaDichVu = $"DV{d}{DateTime.Now.ToString("HHmmss")}";
            DataModel db = new DataModel();
            bool check = db.InsertData(provider, $"INSERT INTO BENHVIEN.DichVuKham VALUES ('{MaDichVu}',N'{txtDVM.Text}',{Int32.Parse(txtGiaDV.Text)})");
        }

        private void btnThemThuoc_Click(object sender, EventArgs e)
        {
            int d = (int)System.DateTime.Now.DayOfWeek;
            string MaThuoc = $"TH{d}{DateTime.Now.ToString("HHmmss")}";
            DataModel db = new DataModel();
            bool check = db.InsertData(provider, $"INSERT INTO BENHVIEN.Thuoc VALUES ('{MaThuoc}',N'{txtThuocM.Text}',{Int32.Parse(txtGiaThuoc.Text)})");
        }

        private void btnXemDVK_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.v_qlcm_dichvukham", dgvDVK);
        }

        private void btnXemDT_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, "SELECT * FROM benhvien.v_qlcm_donthuoc", dgvDT);
        }

        private void btnThemCaTruc_Click(object sender, EventArgs e)
        {
            ThemCaTruc themcatruc = new ThemCaTruc(provider);
            themcatruc.Show();
        }

        private void btnXemDSBN_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
         
            db.DocDuLieu(provider, "select * from benhvien.benhnhan", cbBenhNhan, "MaBN");
            db.DocDuLieu(provider, "SELECT * FROM benhvien.benhnhan", dgvBenhNhan);
            
            db.DocDuLieu(provider, "SELECT * FROM benhvien.v_ttdp", dgvDSK); 
        }

        private void btnTimBN_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, $"select * from benhvien.benhnhan where mabn = '{cbBenhNhan.Text}'", dgvBenhNhan);
            db.DocDuLieu(provider, $"SELECT * FROM benhvien.v_ttdp where mabn = '{cbBenhNhan.Text}'", dgvDSK);
        }

        private void btnThenBN_Click(object sender, EventArgs e)
        {
            ThemBenhNhan thembenhnhan = new ThemBenhNhan(provider);
            thembenhnhan.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            if(textBox1.Text=="")
            {
                MessageBox.Show("Vui lòng nhập mã bệnh nhân");
            }
            else
            {
                db.DocDuLieu(provider, $"select * from BENHVIEN.v_ctdv_ptv where MaKhamBenh = '{textBox1.Text}'", dataGridView1);
            }
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridViewRow row = this.dataGridView1.Rows[e.RowIndex];
            textBox2.Text = row.Cells[1].Value.ToString();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            if (textBox2.Text == "")
            {
                MessageBox.Show("Vui lòng chọn mã CTKB");
            }
            else
            {
                db.UpdateData(provider, $"update BENHVIEN.ct_dvkhambenh set TIEN = {Int32.Parse(textBox3.Text)} where MACTKB='{textBox2.Text}'");
            }
        }
        
        private void button11_Click(object sender, EventArgs e)
        {
            if (textBox11.Text.Length == 0) { }
            string q = textBox11.Text.Length == 0 ? "" : $"where MaKhamBenh = '{textBox11.Text}'";
            DataModel db = new DataModel();
            db.DocDuLieu(provider, $"select* from BENHVIEN.v_bpbt {q}", dataGridView4);
        }
        

        

        private void button13_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, $"select * from benhvien.v_kt", dataGridView5);
        }

        private void btnXemBN_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            string query = txtMaBN.Text == "" ? "" : $"where makhambenh = '{txtMaBN.Text}'";
            db.DocDuLieu(provider, $"select * from benhvien.v_ctdv_ptv {query}", dgvDSDVK);
            
            db.DocDuLieu(provider, $"select * from benhvien.v_ctdt_ptv {query}", dgvDSThuoc);

            db.DocDuLieu(provider, $"select * from benhvien.getDSDVK", cbMaDV,"madichvu");
            db.DocDuLieu(provider, $"select * from benhvien.getDSDVK", cbDVM, "tendichvu");

            db.DocDuLieu(provider, $"select * from benhvien.getDSThuoc", cbMaThuoc, "mathuoc");
            db.DocDuLieu(provider, $"select * from benhvien.getDSThuoc", cbTenThuoc, "tententhuoc");
        }

        private void btnThemMoiDV_Click(object sender, EventArgs e)
        {
            if (txtMaBN.Text == "") { MessageBox.Show("Mã Khám Bệnh Rỗng!"); return; }
            DataModel db = new DataModel();
            int d = (int)System.DateTime.Now.DayOfWeek;
            string CTKB = $"CK{d}{DateTime.Now.ToString("HHmmss")}";
            bool check = db.InsertData(provider, $"INSERT INTO BENHVIEN.CT_DVKhamBenh VALUES ('{txtMaBN.Text}','{CTKB}','{Login.username.ToUpper()}','{cbMaDV.Text}',0)");
        }

        private void cbDVM_SelectedIndexChanged(object sender, EventArgs e)
        {
            cbMaDV.SelectedIndex = cbDVM.SelectedIndex;
        }

        private void btnThemMoiThuoc_Click(object sender, EventArgs e)
        {
            if (txtMaBN.Text == "") { MessageBox.Show("Mã Khám Bệnh Rỗng!"); return; }
            DataModel db = new DataModel();
            int d = (int)System.DateTime.Now.DayOfWeek;
            string CTKB = $"CT{d}{DateTime.Now.ToString("HHmmss")}";
            bool check = db.InsertData(provider, $"INSERT INTO BENHVIEN.CT_DonThuoc VALUES ('{txtMaBN.Text}','{CTKB}','{Login.username.ToUpper()}','{cbMaThuoc.Text}',{Int32.Parse(txtSL.Text)},0)");
        }

        private void cbTenThuoc_SelectedIndexChanged(object sender, EventArgs e)
        {
            cbMaThuoc.SelectedIndex = cbTenThuoc.SelectedIndex;
        }

        private void dgvDSDVK_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if(e.ColumnIndex == 0)
            {
                ThayDoiDVK thayDoi = new ThayDoiDVK(provider, dgvDSDVK.Rows[e.RowIndex].Cells[1].Value.ToString());
                thayDoi.Show();
            }
        }

        private void dgvDSThuoc_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0)
            {
                ThayDoiThuoc thayDoi = new ThayDoiThuoc(provider, dgvDSThuoc.Rows[e.RowIndex].Cells[1].Value.ToString());
                thayDoi.Show();
            }
        }

        private string madichvu_qltl;
        private void button3_Click(object sender, EventArgs e)
        {
            if(this.madichvu_qltl == "") { MessageBox.Show("Chọn Dịch Vụ"); return; };
            DataModel db = new DataModel();
            bool check = db.InsertData(provider, $"update benhvien.dichvukham set tendichvu='{txtDVM.Text}', gia={Int32.Parse(txtGiaDV.Text)}  where madichvu = '{this.madichvu_qltl}'");
            txtDVM.Text = "";
            txtGiaDV.Text = "";
        }

        private void dgvDVKham_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            this.madichvu_qltl = dgvDVKham.Rows[e.RowIndex].Cells[1].Value.ToString();
            txtDVM.Text = dgvDVKham.Rows[e.RowIndex].Cells[2].Value.ToString();
            txtGiaDV.Text = dgvDVKham.Rows[e.RowIndex].Cells[3].Value.ToString();
        }

        private void dgvThuoc_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            this.mathuoc_qltl = dgvThuoc.Rows[e.RowIndex].Cells[1].Value.ToString();
            txtThuocM.Text = dgvThuoc.Rows[e.RowIndex].Cells[2].Value.ToString();
            txtGiaThuoc.Text = dgvThuoc.Rows[e.RowIndex].Cells[3].Value.ToString();
        }
        private string mathuoc_qltl;
        private void button4_Click(object sender, EventArgs e)
        {
            if (this.madichvu_qltl == "") { MessageBox.Show("Chọn Loại Thuốc"); return; };
            DataModel db = new DataModel();
            bool check = db.InsertData(provider, $"update benhvien.thuoc set tententhuoc='{txtThuocM.Text}', DonGia={Int32.Parse(txtGiaThuoc.Text)}  where mathuoc = '{this.mathuoc_qltl}'");
            txtThuocM.Text = "";
            txtGiaThuoc.Text = "";
        }

        private void button5_Click(object sender, EventArgs e)
        {
            DataModel db = new DataModel();
            db.DocDuLieu(provider, $"select * from benhvien.nhanvien", dgvDSNV);
        }
        
    }
}
