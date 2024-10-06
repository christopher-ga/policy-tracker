import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"
import {batchFetchBillData, batchFetchSponsorImage, fetchBillsData} from "../services/congressionalApiService";
import {fetchUserBills} from "../services/billService";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const Bill = () => {

    const [bills, setBills] = useState([])

    useEffect(() => {

        const fetchBills = async () => {

            const billsArray = await fetchBillsData();
            await batchFetchBillData(billsArray);
            await batchFetchSponsorImage(billsArray);
            const userSavedBills = await fetchUserBills();
            console.log(userSavedBills);
            const billsObject = {}

            billsArray.forEach((bill) => {
                billsObject[`${bill.number}_${bill.type}`] = {...bill}
            });

            for (const bill of userSavedBills) {
                if (`${bill.bill_id}_${bill.bill_type}` in billsObject) {
                    billsObject[`${bill.bill_id}_${bill.bill_type}`].saved = true;
                }
            }

            setBills(Object.values(billsObject));
        };

        fetchBills();

    }, []);

    return (
        <>
            <p>bill component</p>
            {bills.map((e) => <BillBannerComponent key={e.number} bill={e}/>)}
        </>
    );
}

export default Bill;