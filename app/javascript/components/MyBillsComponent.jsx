import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"

const MyBillsComponent = () => {

    const [bills, setBills] = useState([])
    const [loading, setLoading] = useState(true)

    useEffect(() => {

        const fetchBills = async () => {

            const bills = await fetch("/api/v1/user_bills")
            const data = await bills.json();
            console.log(data)

            setBills(Object.values(data));
            setLoading(false);
        };

        fetchBills();


    }, []);

    return (
        <>
            <section className="header-container">
                <h2>Currently Tracking</h2>
            </section>

            {loading ? (<div className="loader"></div>) : ( bills.map((e) => <BillBannerComponent key={e.id} bill={e}/>))}

        </>
    );
}

export default MyBillsComponent;