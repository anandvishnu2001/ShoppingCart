<cfheader name="Content-Disposition" value="attachment; filename=Order_Invoice_#url.order#.pdf">

    <cfheader name="Content-Type" value="application/pdf">

    <cfcontent type="application/pdf" reset="true">

    <cfset variables.orders = application.control.getOrder(order=url.order)>
    
    <cfdocument format="PDF" orientation="portrait">
    
        <cfoutput>
            <div id="border">
                <div id="head">
                    <img style="margin-right: 0px; width: 40%; float: right;" src="/images/shop.png">
                    <div>
                        <h1 style="color: blue;">
                            <strong>ShopKart</strong>
                        </h1>
                        <h2>
                            <strong>INVOICE</strong>
                        </h2>
                    </div>
                </div>

                <div class="box">
                    <p><strong>Order Number:</strong> #variables.orders[1].id#</p>
                    <p><strong>Invoice Date:</strong> #dateFormat(variables.orders[1].date, "mm/dd/yyyy")#</p>
                </div>

                <div class="box">
                    <p><strong>Bill To:</strong></p>
                    <p>Contact Name: #variables.orders[1].shipping.name#</p>
                    <p>
                        Shipping Address:
                            #variables.orders[1].shipping.house#,
                            #variables.orders[1].shipping.street#,
                            #variables.orders[1].shipping.city#,
                            #variables.orders[1].shipping.state#,
                            #variables.orders[1].shipping.country#
                            PIN - #variables.orders[1].shipping.pincode#
                    </p>
                    <p>Phone: #variables.orders[1].shipping.phone#</p>
                </div>

                <table style="">
                    <thead>
                        <tr style="background-color: skyblue;">
                            <th>Item Name</th>
                            <th>Qty</th>
                            <th>Unit Price</th>
                            <th>Tax Rate</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array="#variables.orders[1].items#" index="item">
                            <tr>
                                <td>#item.name#</td>
                                <td>#item.quantity#</td>
                                <td>#chr(8377)##numberFormat(item.price)#</td>
                                <td>#item.tax#%</td>
                                <td>#chr(8377)##numberFormat(item.totalprice)#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>

                <p class="text-right"><strong>Total Due:</strong> #chr(8377)##numberFormat(variables.orders[1].totalprice)#</p>
                <hr>
                <p class="text-right"><strong>Tax:</strong> #chr(8377)##numberFormat(variables.orders[1].totaltax)#</p>
                <hr>
                <p class="text-right"><strong>Total Payed:</strong> #chr(8377)##numberFormat(variables.orders[1].totalprice)#</p>
                <hr>

                <div style="margin-top: 30px;">
                    <p><strong>Payment Information:</strong> This invoice was paid by card ending in XX4321. The payment has been confirmed and processed.</p>
                    <p style="text-align: center;">Thank you for shopping with us!</p>
                </div>
            </div>
        </cfoutput>
            <style>
                strong{
                    font-family: Georgia;
                }
                #border{
                    margin-top: 0;
                    width: 100%;
                    border-top: 10px solid blue;
                    border-bottom: 10px solid blue;
                }
                #head{
                    margin: 10px;
                    width: 100%;
                    display: flex;
                }
                .text-right{
                    text-align: right;
                }
                table{
                    width: 100%;
                    border: 1px double black;
                    margin-top: 20px;
                    color: white;
                    background-color: darkcyan;
                }
                th,td{
                    border: 1px solid black;
                    padding: 10px;
                }
                .box{
                    margin: 20px;
                    border: 1px solid black;
                    padding: 10px;
                }
            </style>
    </cfdocument>
