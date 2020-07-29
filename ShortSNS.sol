pragma solidity ^0.5.0;

contract noncense {
    struct post {
        address author;
        uint32 time;
        string contents;
        MsgState state;
    }
    
    post[] public posts;
    
    event AlertPost (
        address indexed author,
        uint indexed id,
        MsgState indexed state
    );
    
    enum MsgState {
        Delete,
        New,
        Update
    }
    
    function getNumPost() public view returns(uint){
        return posts.length;
    }
    
    function newPost(string memory contents) public {
        posts.push(post({
            author : msg.sender,
            time : uint32(now),
            contents : contents,
            state : MsgState.New
        }));
        
        emit AlertPost(msg.sender, posts.length - 1 , MsgState.New);
    }
    
    function updatePost(uint id, string memory contents) public {
        require(posts[id].author == msg.sender, "Only author can modify this post");
        require(posts[id].state != MsgState.Delete, "This is delete post");
        
        posts[id].time = uint32(now);
        posts[id].contents = contents;
        posts[id].state = MsgState.Update;
        
        emit AlertPost(msg.sender, id, MsgState.Update);
    }
    
    function deletePost(uint id) public {
        require(posts[id].author == msg.sender, "Only author can modify this post");
        
        delete posts[id];
        
        emit AlertPost(msg.sender, id, MsgState.Delete);
    }
}