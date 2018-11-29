pragma solidity ^0.4.3;
contract Poll {
    //model a topic
    struct Topic {
        uint id;    // can be 0
        string question;
        uint choiceCount;
        address creator;
        bool isFinished;
        mapping (uint => Choice) choices;
        mapping (address => bool) voters;
    }
    
    struct Choice {
        uint id;
        string answer;
        uint count;
    }
    
    // Store accounts that have voted
    
    // List of Topics
    mapping (uint => Topic) public topics;
    
    uint topicsCount;
    
    function addTopic (string _question) public {
        topics[topicsCount] = Topic(topicsCount, _question, 0, msg.sender, false);
    }
    
    // Add each for each choice
    function addChoice (string _choice) public {
        Topic storage t = topics[topicsCount];
        t.choices[t.choiceCount] = Choice({id:t.choiceCount, answer:_choice, count:0});
        t.choiceCount++;
    }
    
    function stepTopicsCount () public {
        topicsCount++;
    }
    
    //maybe dont use it
    function isCreator (uint _topicID) public view returns (bool _isCreator) {
        Topic storage t = topics[_topicID];
        if (t.creator == msg.sender)
            return true;
        return false;
    }
    
    function vote (uint _topicID, uint _choiceID) public {
        Topic storage t = topics[_topicID];
        
        // require that they haven't voted before
        require(!t.voters[msg.sender]);
        
        // require a valid topic
        require(_topicID >= 0 && _topicID < topicsCount);
        
        // require a valid choice
        require(_choiceID >= 0 && _choiceID < t.choiceCount);
        
        // require that the topic hasn't end yet
        require(!t.isFinished);
        
        // check as voted
        t.voters[msg.sender] = true;
        
        // update counter
        t.choices[_choiceID].count++;
        
        // trigger voted event
        //votedEvent(_candidateId);
    }
    
    function endPoll (uint _topicID) public {
        // require creator to end poll
        require(msg.sender == topics[_topicID].creator);
        
        // it is not ended
        require(!topics[_topicID].isFinished);
        
        topics[_topicID].isFinished = true;
    }
    
}