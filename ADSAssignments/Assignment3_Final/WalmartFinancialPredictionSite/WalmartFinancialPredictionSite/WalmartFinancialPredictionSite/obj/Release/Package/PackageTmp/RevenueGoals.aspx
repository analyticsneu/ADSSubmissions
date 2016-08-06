<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RevenueGoals.aspx.cs" Inherits="WalmartFinancialPredictionSite.RevenueGoals" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Define Your Revenue Goal</title>
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
    <div>
    
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
						Size
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Size" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Temperature
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Temp" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Fuel Price
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Fuel_Price" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						CPI
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_CPI" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>


                <asp:TableRow>
                    <asp:TableCell>
						Unemployment
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Unemployment" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

               
            </asp:Table>

            <div>
                <div>
                    <asp:Button ID="btn_Submit" runat="server" Text="Submit" OnClick="btn_Submit_Click" />
                    <br />
                    <br />
                    <br />
                </div>
            </div>
            <div>
                <asp:FileUpload ID="FileUpload1" runat="server" />
                <asp:Button ID="btnUpload" runat="server" Text="Upload"
                    OnClick="btnUpload_Click" style="margin-top: 0px" Width="118px" />
                <br />
                <asp:Label ID="Label1" runat="server" Text="Has Header ?" />
                <asp:RadioButtonList ID="rbHDR" runat="server">
                    <asp:ListItem Text="Yes" Value="Yes" Selected="True">
                    </asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                </asp:RadioButtonList>
                <asp:GridView ID="GridView1" runat="server"
                    OnPageIndexChanging="PageIndexChanging" AllowPaging="true">
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
