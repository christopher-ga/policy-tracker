import React, {useEffect, useState} from "react"
import BillBannerComponent from "./BillBannerComponent"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

const Bill = () => {

    const [bills, setBills] = useState([])

    useEffect(() => {
        const fetchBills = async () => {
            const response = await fetch("/bills/data");
            const data = await response.json();
            const billStorage = {};

            const fetchBillDataPromises = data.bills.map(async (bill) => {
                const moreBillData = await fetch("/bills/bill_data", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify({ _json: bill.url })
                });

                const billData = await moreBillData.json();

                billStorage[bill.number] = {
                    "congress": bill.congress,
                    "title": bill.title,
                    "number": bill.number,
                    "updateDate": bill.updateDate,
                    "url": bill.url,
                    "type": bill.type,

                    "introducedDate": billData.bill?.introducedDate,
                    "latestAction": billData.bill?.latestAction?.text,
                    "sponsorFirstName": billData.bill.sponsors[0]?.firstName,
                    "sponsorLastName": billData.bill.sponsors[0]?.lastName,
                    "sponsorParty": billData.bill.sponsors[0]?.party,
                    "sponsorState": billData.bill.sponsors[0]?.state,
                    "sponsorUrl": billData.bill.sponsors[0]?.url
                };
            });

            await Promise.all(fetchBillDataPromises);
            const fetchSponsorDataPromises = Object.values(billStorage).map(async (bill) => {
                if (bill.sponsorUrl) {
                    const sponsorDataResponse = await fetch("/bills/sponsor_data", {
                        method: "POST",
                        headers: {
                            'Content-Type': 'application/json',
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: JSON.stringify({_json: bill.sponsorUrl})
                    });

                    const sponsorData = await sponsorDataResponse.json();

                    bill.sponsorUrl = sponsorData.member.depiction.imageUrl
                }
            });

            await Promise.all(fetchSponsorDataPromises);

            setBills(Object.values(billStorage));
            console.log(billStorage);

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