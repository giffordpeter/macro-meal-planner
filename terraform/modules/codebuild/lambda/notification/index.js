const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    const buildStatus = event.detail['build-status'];
    const projectName = event.detail['project-name'];
    const buildId = event.detail['build-id'];
    const region = event.region;
    
    const projectEnv = process.env.ENVIRONMENT;
    const projectName = process.env.PROJECT_NAME;
    
    let statusEmoji;
    switch(buildStatus) {
        case 'SUCCEEDED':
            statusEmoji = '✅';
            break;
        case 'FAILED':
            statusEmoji = '❌';
            break;
        case 'STOPPED':
            statusEmoji = '⚠️';
            break;
        default:
            statusEmoji = 'ℹ️';
    }
    
    const message = {
        text: `${statusEmoji} Database Migration Status Update\n` +
              `Environment: ${projectEnv}\n` +
              `Project: ${projectName}\n` +
              `Status: ${buildStatus}\n` +
              `Build ID: ${buildId}\n\n` +
              `Console Link: https://${region}.console.aws.amazon.com/codesuite/codebuild/${buildId.split(':')[1]}/projects/${projectName}/build/${buildId.split('/')[1]}`,
        
        blocks: [
            {
                type: "header",
                text: {
                    type: "plain_text",
                    text: `${statusEmoji} Database Migration: ${buildStatus}`
                }
            },
            {
                type: "section",
                fields: [
                    {
                        type: "mrkdwn",
                        text: `*Environment:*\n${projectEnv}`
                    },
                    {
                        type: "mrkdwn",
                        text: `*Project:*\n${projectName}`
                    }
                ]
            },
            {
                type: "section",
                fields: [
                    {
                        type: "mrkdwn",
                        text: `*Status:*\n${buildStatus}`
                    },
                    {
                        type: "mrkdwn",
                        text: `*Build ID:*\n${buildId.split('/')[1]}`
                    }
                ]
            },
            {
                type: "actions",
                elements: [
                    {
                        type: "button",
                        text: {
                            type: "plain_text",
                            text: "View in Console"
                        },
                        url: `https://${region}.console.aws.amazon.com/codesuite/codebuild/${buildId.split(':')[1]}/projects/${projectName}/build/${buildId.split('/')[1]}`
                    }
                ]
            }
        ]
    };
    
    try {
        await sns.publish({
            TopicArn: process.env.SNS_TOPIC_ARN,
            Message: JSON.stringify(message),
            MessageAttributes: {
                'status': {
                    DataType: 'String',
                    StringValue: buildStatus
                }
            }
        }).promise();
        
        console.log('Successfully published notification');
        return {
            statusCode: 200,
            body: 'Notification sent successfully'
        };
    } catch (error) {
        console.error('Error publishing notification:', error);
        throw error;
    }
};
