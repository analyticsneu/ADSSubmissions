<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DefineProfitLoss.aspx.cs" Inherits="WalmartFinancialPredictionSite.DefineProfitLoss" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
         <div>
    
    	<asp:Label ID="lbl_header" runat="server" Font-Size="XX-Large" Text="Walmart Financial Statistics"></asp:Label>
		<br />
		<br />
		<br />
		<asp:Table ID="Table2" runat="server" Width="384px" GridLines="Both">
			<asp:TableRow>
                <asp:TableCell>
          <asp:HyperLink ID="hyp_home" NavigateUrl="~/HomePage.aspx" runat="server">Home</asp:HyperLink>
					</asp:TableCell>
					<asp:TableCell>
          <asp:HyperLink ID="hyp_predict" NavigateUrl="~/SalesPrediction.aspx" runat="server">Predice Sales of a Store.</asp:HyperLink>
					</asp:TableCell>
					<asp:TableCell>
          <asp:HyperLink ID="hyp_profit" NavigateUrl="~/DefineProfitLoss.aspx" runat="server">Find Profit/Loss</asp:HyperLink>
					</asp:TableCell>
					<asp:TableCell>
          <asp:HyperLink ID="hyp_sales" NavigateUrl="~/RevenueGoals.aspx" runat="server">Find the mean sales</asp:HyperLink>
					</asp:TableCell>					
				</asp:TableRow>
		</asp:Table>
		<br />
    
    </div>
		<p>
			<asp:Table ID="Table1" runat="server" Height="73px" Width="335px" BorderColor="Black" GridLines="Both">
				<asp:TableRow>
					<asp:TableCell>
           Column
					</asp:TableCell>
					<asp:TableCell>
          Value
					</asp:TableCell>
				</asp:TableRow>
				<asp:TableRow>
					<asp:TableCell>
						Store No
					</asp:TableCell>
					<asp:TableCell>
						<asp:TextBox ID="txt_StoreNo" runat="server"></asp:TextBox>
					</asp:TableCell>
				</asp:TableRow>

				<asp:TableRow>
					<asp:TableCell>
						Department No
					</asp:TableCell>
					<asp:TableCell>
						<asp:TextBox ID="txt_DeptNo" runat="server"></asp:TextBox>
					</asp:TableCell>
				</asp:TableRow>

				<asp:TableRow>
					<asp:TableCell>
						Month of year
					</asp:TableCell>
					<asp:TableCell>
						<asp:TextBox ID="txt_month" runat="server"></asp:TextBox>
					</asp:TableCell>
				</asp:TableRow>
				
					<asp:TableRow>
					<asp:TableCell>
						year
					</asp:TableCell>
					<asp:TableCell>
						<asp:TextBox ID="txt_Year" runat="server"></asp:TextBox>
					</asp:TableCell>
				</asp:TableRow>
			</asp:Table>
		</p>
		<div>
			<div>
				<asp:Button ID="btn_Submit" runat="server" Text="Submit" OnClick="btn_Submit_Click" />
			</div>
		</div>
		Is it in profit:
		<asp:Label ID="Label1" runat="server"></asp:Label>

		<br />
		<br />

        <asp:FileUpload ID="FileUpload2" runat="server" />
<asp:Button ID="btnUpload" runat="server" Text="Upload"
            OnClick="btnUpload_Click" />
<br />
<asp:Label ID="Label2" runat="server" Text="Has Header ?" />
<asp:RadioButtonList ID="rbHDR" runat="server">
    <asp:ListItem Text = "Yes" Value = "Yes" Selected = "True" >
    </asp:ListItem>
    <asp:ListItem Text = "No" Value = "No"></asp:ListItem>
</asp:RadioButtonList>
<asp:GridView ID="GridView1" runat="server"
OnPageIndexChanging = "PageIndexChanging" AllowPaging = "true">
</asp:GridView>

		<br />
		<br />
		<asp:FileUpload ID="FileUpload1" runat="server" />
        <br/>
        <asp:Button ID="UploadButton" runat="server"
                    OnClick="UploadButton_Click"
                    Text="Upload File" />
        <br/>
        <asp:Label ID="FileUploadedLabel" runat="server" />
	</form>
</body>
</html>
