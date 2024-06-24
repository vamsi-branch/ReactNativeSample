import branch from "react-native-branch";

export const sendAppInstanceIdToBranch = async () => {
    //const appInstanceId = (await analytics().getAppInstanceId()) ?? '';

    branch.setRequestMetadata('$firebase_app_instance_id', '1234');
    setTimeout(() => {
        branch.subscribe(() => {
            console.log("called from inside subscribe");
        });
    }, 5000);
    };