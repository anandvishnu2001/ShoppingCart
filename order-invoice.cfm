<cfheader name="Content-Disposition" value="attachment; filename=Order_Invoice_#url.order#.pdf">

    <cfheader name="Content-Type" value="application/pdf">

    <cfcontent type="application/pdf" reset="true">

    <cfset control = CreateObject("component", "components.control")>
    <cfset variables.orders = control.getOrder(order=url.order)>
    
    <cfdocument format="PDF" orientation="portrait">
    
        <cfoutput>
            <div style="margin-top: 0; width: 100%; border-top: 10px solid blue; border-bottom: 10px solid blue;">
                <div style="margin: 10px; display: flex;">
                    <img style="margin-right: 0px; width: 40%; float: right;" src="/images/shop.png">
                    <div style="text-align: left;">
                        <h1 style="color: blue;">
                            <strong>Shopping Cart</strong>
                        </h1>
                        <h2 style="font-family: Georgia;">INVOICE</h2>
                    </div>
                </div>

                <div style="margin: 20px;">
                    <p><strong>Order Number:</strong> #variables.orders[1].id#</p>
                    <p><strong>Invoice Date:</strong> #dateFormat(variables.orders[1].date, "mm/dd/yyyy")#</p>
                </div>

                <div style="margin: 20px; border: 1px solid black; padding: 10px;">
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

                <table style="width: 100%; border: 1px double black; margin-top: 20px; color: white; background-color: darkcyan;">
                    <thead>
                        <tr style="border: 1px solid black; background-color: skyblue;">
                            <th style="border: 1px solid black; padding: 10px;">Description</th>
                            <th style="border: 1px solid black; padding: 10px;">Qty</th>
                            <th style="border: 1px solid black; padding: 10px;">Unit Price</th>
                            <th style="border: 1px solid black; padding: 10px;">Tax</th>
                            <th style="border: 1px solid black; padding: 10px;">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset variables.total = 0>
                        <cfset variables.tax = 0>
                        <cfloop array="#variables.orders[1].items#" index="item">
                            <tr>
                                <td style="border: 1px solid black; padding: 10px;">#item.name#</td>
                                <td style="border: 1px solid black; padding: 10px;">#item.quantity#</td>
                                <td style="border: 1px solid black; padding: 10px;">#chr(8377)##numberFormat(item.price+(item.price*item.tax/100),'__.00')#</td>
                                <td style="border: 1px solid black; padding: 10px;">#item.tax#%</td>
                                <td style="border: 1px solid black; padding: 10px;">#chr(8377)##numberFormat(item.quantity*(item.price+(item.price*item.tax/100)),'__.00')#</td>
                            </tr>
                            <cfset variables.total += item.quantity*(item.price+(item.price*item.tax/100))>
                            <cfset variables.tax += item.quantity*(item.price*item.tax/100)>
                        </cfloop>
                    </tbody>
                </table>

                <p style="text-align: right;"><strong>Total Due:</strong> #chr(8377)##numberFormat(variables.total, '__.00')#</p>
                <hr>
                <p style="text-align: right;"><strong>Tax:</strong> #chr(8377)##numberFormat(variables.tax, '__.00')#</p>
                <hr>
                <p style="text-align: right;"><strong>Total Payed:</strong> #chr(8377)##numberFormat(variables.total, '__.00')#</p>
                <hr>

                <div style="margin-top: 30px;">
                    <p><strong>Payment Information:</strong> This invoice was paid by card ending in XX4321. The payment has been confirmed and processed.</p>
                    <p>Thank you for shopping with us!</p>
                </div>
            </div>
        </cfoutput>
    </cfdocument>
