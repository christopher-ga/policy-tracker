import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"

const Bill = () => {

    const [bills, setBills] = useState([])

    useEffect(() => {

        const fetchBills = async () => {

            const bills = await fetch("/api/v1/user_bills")
            const data = await bills.json();
            console.log(data)

            setBills(Object.values(data));
        };

        fetchBills();

    }, []);

    return (
        <>
            <h2>Currently Tracking</h2>

            {bills.map((e) => <BillBannerComponent key={e.number} bill={e}/>)}
        </>
    );
}

export default Bill;