<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="WalmartFinancialPredictionSite.HomePage" %>

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
		<asp:Table ID="Table1" runat="server" Width="384px" GridLines="Both">
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
    </form>
</body>
</html>

