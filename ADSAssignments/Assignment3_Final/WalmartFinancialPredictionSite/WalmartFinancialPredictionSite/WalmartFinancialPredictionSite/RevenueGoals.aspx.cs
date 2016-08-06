using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Configuration;
using System.Data;

namespace WalmartFinancialPredictionSite
{
    public partial class RevenueGoals : System.Web.UI.Page
    {
        ClusteringCode c = new ClusteringCode();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                string FileName = Path.GetFileName(FileUpload1.PostedFile.FileName);
                string Extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                string FolderPath = ConfigurationManager.AppSettings["FolderPath"];

                string FilePath = Server.MapPath(FolderPath + FileName);
                FileUpload1.SaveAs(FilePath);
                DataTable dt = c.Import_To_Grid(FilePath, Extension, rbHDR.SelectedItem.Text);
            }
        }
        protected void PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            string FolderPath = ConfigurationManager.AppSettings["FolderPath"];
            string FileName = GridView1.Caption;
            string Extension = Path.GetExtension(FileName);
            string FilePath = Server.MapPath(FolderPath + FileName);

            DataTable dt = c.Import_To_Grid(FilePath, Extension, rbHDR.SelectedItem.Text);
            GridView1.Caption = Path.GetFileName(FilePath);
            GridView1.DataSource = dt;
            GridView1.DataBind();

        }

        protected void btn_Submit_Click(object sender, EventArgs e)
        {
            String temp = txt_Temp.Text ;
            String unemp = txt_Unemployment.Text;
            String fuelPrice = txt_Fuel_Price.Text;
            String cpi = txt_CPI.Text;
            String size = txt_Size.Text;
            ClusteringCode c = new ClusteringCode(temp, unemp, fuelPrice, cpi,size);
            Label1.Text = c.Result;
        }
    }
}