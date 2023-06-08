import {OnPremisesPublishing} from "./onPremisesPublishing.js";

export type Application = {
    name: string
    appRoleAssignmentRequired: boolean
    appRoleAssignments: string[]
    onPremisesPublishing: OnPremisesPublishing
}
