SELECT
	checkout.item_record_id AS "Id",
	checkout.checkout_gmt AT TIME ZONE 'EST' AS "Checkout Date",
	brp.best_title AS "Title",
	brp.best_author AS "Author",
	concat((TRIM(REGEXP_REPLACE(cn.field_content,'\|.',' ','g')))) AS "Call Number",
	checkout.ptype AS "Patron Type",
	checkout.loanrule_code_num AS "Loan Rule Number",
	bc.field_content AS "Item Barcode"
FROM
	sierra_view.checkout
INNER JOIN
	sierra_view.bib_record_item_record_link bil ON checkout.item_record_id = bil.item_record_id
INNER JOIN
	sierra_view.bib_record_property brp ON bil.bib_record_id = brp.bib_record_id
LEFT JOIN
	sierra_view.varfield bc on (checkout.item_record_id = bc.record_id AND bc.varfield_type_code = 'b')
LEFT JOIN
	sierra_view.varfield cn on (checkout.item_record_id = cn.record_id AND cn.varfield_type_code = 'c')
WHERE
	checkout.checkout_gmt > current_date - 730 AND
	checkout.loanrule_code_num IN (100, 101, 102, 103, 108, 109, 110, 111, 112, 272, 273, 274, 276, 277, 284, 285, 297, 298, 299, 300) AND
	checkout.ptype BETWEEN 0 AND 12
ORDER BY
	checkout.checkout_gmt DESC
LIMIT 5000;