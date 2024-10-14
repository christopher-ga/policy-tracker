import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"
import SearchComponent from "./SearchComponent";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const Bill = () => {

    const [bills, setBills] = useState([])

    useEffect(() => {

        const fetchBills = async () => {

            const bills = await fetch("/api/v1/bills")
            const data = await bills.json();
            console.log(data)


            setBills(Object.values(data));
        };

        fetchBills();

    }, []);

    return (
        <>
            <SearchComponent setBills={setBills}></SearchComponent>
            {bills.map((e) => <BillBannerComponent key={e.number} bill={e}/>)}
        </>
    );
}

export default Bill;