import { useState, useEffect } from './preact.standalone.module.js';

const useCookie = (name, initialValue) => {
    const [value, setValue] = useState(() => {
        const storedValue = JSON.parse(localStorage.getItem(name) || 'null');
        if (storedValue === null)
            return initialValue;

        return storedValue;
    });

    useEffect(() => {
        localStorage.setItem(name, JSON.stringify(value));
    }, [name, value]);

    return [value ?? initialValue, setValue];
}

export default useCookie;