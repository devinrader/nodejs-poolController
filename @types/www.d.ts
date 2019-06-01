export as namespace WWW;
export = WWW;

declare namespace WWW
{
    export interface ISysInfo
    {
        airTemp: number;
        solarTemp: number;
        freezeProt: ZeroOrOne
        time: string;
        date: string;
        locale: string;
        controllerDateStr: string;
        controllerTime: string;
    }

    export interface IPoolOrSpaState
    {
        state: "On" | "Off";
        number: number;
        name: "Pool" | "Spa",
        temperature: number;
        lastKnownTemperature: number;
        setPoint: number;
        heatMode: number;
        heatModeStr: string;
        heaterActive: ZeroOrOne;
        solarActive: ZeroOrOne
    }
}