<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SalesPrediction.aspx.cs" Inherits="WalmartFinancialPredictionSite.SalesPrediction" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
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
    <form id="form1" runat="server">

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
						year
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_year" runat="server"></asp:TextBox>
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
						Day of Month
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_dayOfMonth" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Days
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Days" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Day_Index
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_DayIndex" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Is Holiday
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_IsHoliday" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Type
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Type" runat="server"></asp:TextBox>
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
                        <asp:TextBox ID="txt_FuelPrice" runat="server"></asp:TextBox>
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
						Weekly Sales
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_WeeklySales" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Holiday
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_Holiday" runat="server"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>

                <asp:TableRow>
                    <asp:TableCell>
						Markdown
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:TextBox ID="txt_MarkDown" runat="server"></asp:TextBox>
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
