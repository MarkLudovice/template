//Displaying request transactions in tbody.

<tbody>
    <tr class="odd gradeX">
        <?php 
            $sql = mysql_query("SELECT supply_ris_t.ris_no,supply_stock_t.stock_no, supply_category_t.sc_name, supply_subcat_t.ssc_name, supply_acquired_t.quantity_requested, supply_ris_t.date_requested, supply_ris_t.status, supply_ris_t.date_approved, employee_t.emp_fname, employee_t.emp_sname 
                    FROM supply_item_t, supply_category_t, supply_subcat_t, inv_unit_t, supply_stock_t, supply_acquired_t, supply_ris_t, employee_t 
                    WHERE supply_item_t.ssc_no=supply_subcat_t.ssc_no AND supply_subcat_t.sc_no=supply_category_t.sc_no 
                    AND supply_item_t.unit_no=inv_unit_t.unit_no AND supply_item_t.si_id = supply_stock_t.si_id 
                    AND supply_stock_t.stock_no = supply_acquired_t.stock_no AND supply_acquired_t.ris_no = supply_ris_t.ris_no AND employee_t.emp_no = supply_ris_t.emp_no AND supply_ris_t.status='approved' ") or die(mysql_error());
            while($row = mysql_fetch_assoc($sql)){

            ?>
        <td><?php echo $row['ris_no'];?></td>
        <td><?php echo $row['stock_no']?></td>
        <td>
            <!--start popover on right -->
            <a href="#" data-container="body" data-toggle="popover" data-placement="right" data-content='test, image cannot be displayed, please try calling image from database in the next test'>
                <?php echo $row['ssc_name']." ".$row['sc_name'];?>
            </a>
            <!--end popover on right -->
        </td>
        <td><?php echo $row['quantity_requested'];?></td>
        <td><?php echo $row['date_requested'];?></td>
        <td class="center"><?php echo $row['emp_fname']." ".$row['emp_sname'];?></td>
        <td class="center"><?php echo $row['date_approved'];?></td>
    </tr>
        <?php
            }
        ?>
</tbody>