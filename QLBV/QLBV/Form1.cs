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
    }
}
