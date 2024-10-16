import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"
import SearchComponent from "./SearchComponent";

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const Bill = () => {

    const [bills, setBills] = useState([])
    const [loading, setLoading] = useState(true)

    useEffect(() => {

        const fetchBills = async () => {

            const bills = await fetch("/api/v1/bills")
            const data = await bills.json();
            setBills(Object.values(data));
            setLoading(false)
        };

        fetchBills();


    }, []);

    return (
        <>
            <SearchComponent isLoading={setLoading} setBills={setBills}></SearchComponent>
            {loading ? (<div className="loader"></div>) : ( bills.map((e) => <BillBannerComponent key={e.id} bill={e}/>))}
        </>
    );
}

export default Bill;