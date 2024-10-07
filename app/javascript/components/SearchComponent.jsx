import {searchForBills} from "../services/congressionalApiService";
import React, {useState} from "react";
import BillBannerComponent from "./BillBannerComponent";

const SearchComponent = () => {

    const [bills, setBills] = useState([])
    const [searchTerms, setSearchTerms] = useState('')

    const handleSearch = async () => {
        const billsArray = await searchForBills(searchTerms)
        setBills(billsArray.results)
    }

    const handleSearchTerms = (e) => {
        setSearchTerms(e.target.value);
    };

    return (
        <>
            <input type="text"
                   value={searchTerms}
                   onChange={handleSearchTerms}
            />
            <button onClick={handleSearch}>click to test search function</button>
            {bills.map((e) => <BillBannerComponent key={e.packageId} bill={e}></BillBannerComponent>)}

        </>
    )
}

export default SearchComponent