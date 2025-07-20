-- =================================================
-- RLS (Row Level Security) 정책 설정
-- Supabase 보안 정책 - 콘텐츠 공유 앱
-- =================================================

-- 1. 모든 테이블에 RLS 활성화
-- =================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comment_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- =================================================
-- 2. Users 테이블 정책
-- =================================================

-- 모든 사용자 프로필 조회 가능 (공개 정보만)
DROP POLICY IF EXISTS "Users are viewable by everyone" ON public.users;
CREATE POLICY "Users are viewable by everyone" ON public.users
    FOR SELECT USING (is_active = true);

-- 자신의 프로필만 수정 가능
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- =================================================
-- 3. Contents 테이블 정책
-- =================================================

-- 공개된 콘텐츠는 모든 사용자가 조회 가능
DROP POLICY IF EXISTS "Published contents are viewable by everyone" ON public.contents;
CREATE POLICY "Published contents are viewable by everyone" ON public.contents
    FOR SELECT USING (status = 'published');

-- 작성자는 자신의 모든 콘텐츠 조회 가능
DROP POLICY IF EXISTS "Authors can view own contents" ON public.contents;
CREATE POLICY "Authors can view own contents" ON public.contents
    FOR SELECT USING (auth.uid() = author_id);

-- 인증된 사용자는 콘텐츠 생성 가능
DROP POLICY IF EXISTS "Authenticated users can create contents" ON public.contents;
CREATE POLICY "Authenticated users can create contents" ON public.contents
    FOR INSERT WITH CHECK (auth.uid() = author_id);

-- 작성자는 자신의 콘텐츠 수정 가능
DROP POLICY IF EXISTS "Authors can update own contents" ON public.contents;
CREATE POLICY "Authors can update own contents" ON public.contents
    FOR UPDATE USING (auth.uid() = author_id);

-- 작성자는 자신의 콘텐츠 삭제 가능
DROP POLICY IF EXISTS "Authors can delete own contents" ON public.contents;
CREATE POLICY "Authors can delete own contents" ON public.contents
    FOR DELETE USING (auth.uid() = author_id);

-- =================================================
-- 4. Categories 테이블 정책
-- =================================================

-- 활성화된 카테고리는 모든 사용자가 조회 가능
DROP POLICY IF EXISTS "Active categories are viewable by everyone" ON public.categories;
CREATE POLICY "Active categories are viewable by everyone" ON public.categories
    FOR SELECT USING (is_active = true);

-- =================================================
-- 5. Tags 테이블 정책
-- =================================================

-- 모든 태그는 모든 사용자가 조회 가능
DROP POLICY IF EXISTS "Tags are viewable by everyone" ON public.tags;
CREATE POLICY "Tags are viewable by everyone" ON public.tags
    FOR SELECT USING (true);

-- =================================================
-- 6. Content Categories 테이블 정책
-- =================================================

-- 모든 사용자가 콘텐츠-카테고리 연결 조회 가능
DROP POLICY IF EXISTS "Content categories are viewable by everyone" ON public.content_categories;
CREATE POLICY "Content categories are viewable by everyone" ON public.content_categories
    FOR SELECT USING (true);

-- 콘텐츠 작성자만 카테고리 연결 가능
DROP POLICY IF EXISTS "Content authors can manage categories" ON public.content_categories;
CREATE POLICY "Content authors can manage categories" ON public.content_categories
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.contents 
            WHERE id = content_id AND author_id = auth.uid()
        )
    );

-- =================================================
-- 7. Content Tags 테이블 정책
-- =================================================

-- 모든 사용자가 콘텐츠-태그 연결 조회 가능
DROP POLICY IF EXISTS "Content tags are viewable by everyone" ON public.content_tags;
CREATE POLICY "Content tags are viewable by everyone" ON public.content_tags
    FOR SELECT USING (true);

-- 콘텐츠 작성자만 태그 연결 가능
DROP POLICY IF EXISTS "Content authors can manage tags" ON public.content_tags;
CREATE POLICY "Content authors can manage tags" ON public.content_tags
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.contents 
            WHERE id = content_id AND author_id = auth.uid()
        )
    );

-- =================================================
-- 8. Content Likes 테이블 정책
-- =================================================

-- 모든 사용자가 좋아요 정보 조회 가능
DROP POLICY IF EXISTS "Content likes are viewable by everyone" ON public.content_likes;
CREATE POLICY "Content likes are viewable by everyone" ON public.content_likes
    FOR SELECT USING (true);

-- 인증된 사용자는 자신의 좋아요 추가/삭제 가능
DROP POLICY IF EXISTS "Users can manage own likes" ON public.content_likes;
CREATE POLICY "Users can manage own likes" ON public.content_likes
    FOR ALL USING (auth.uid() = user_id);

-- =================================================
-- 9. Content Bookmarks 테이블 정책
-- =================================================

-- 사용자는 자신의 북마크만 조회 가능
DROP POLICY IF EXISTS "Users can view own bookmarks" ON public.content_bookmarks;
CREATE POLICY "Users can view own bookmarks" ON public.content_bookmarks
    FOR SELECT USING (auth.uid() = user_id);

-- 인증된 사용자는 자신의 북마크 추가/삭제 가능
DROP POLICY IF EXISTS "Users can manage own bookmarks" ON public.content_bookmarks;
CREATE POLICY "Users can manage own bookmarks" ON public.content_bookmarks
    FOR ALL USING (auth.uid() = user_id);

-- =================================================
-- 10. Comments 테이블 정책
-- =================================================

-- 삭제되지 않은 댓글은 모든 사용자가 조회 가능
DROP POLICY IF EXISTS "Non-deleted comments are viewable by everyone" ON public.comments;
CREATE POLICY "Non-deleted comments are viewable by everyone" ON public.comments
    FOR SELECT USING (is_deleted = false);

-- 댓글 작성자는 자신의 모든 댓글 조회 가능 (삭제된 것도 포함)
DROP POLICY IF EXISTS "Comment authors can view own comments" ON public.comments;
CREATE POLICY "Comment authors can view own comments" ON public.comments
    FOR SELECT USING (auth.uid() = user_id);

-- 인증된 사용자는 댓글 생성 가능
DROP POLICY IF EXISTS "Authenticated users can create comments" ON public.comments;
CREATE POLICY "Authenticated users can create comments" ON public.comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 댓글 작성자는 자신의 댓글 수정 가능
DROP POLICY IF EXISTS "Comment authors can update own comments" ON public.comments;
CREATE POLICY "Comment authors can update own comments" ON public.comments
    FOR UPDATE USING (auth.uid() = user_id);

-- 댓글 작성자는 자신의 댓글 삭제 가능 (실제로는 is_deleted = true로 변경)
DROP POLICY IF EXISTS "Comment authors can delete own comments" ON public.comments;
CREATE POLICY "Comment authors can delete own comments" ON public.comments
    FOR UPDATE USING (auth.uid() = user_id);

-- =================================================
-- 11. Comment Likes 테이블 정책
-- =================================================

-- 모든 사용자가 댓글 좋아요 정보 조회 가능
DROP POLICY IF EXISTS "Comment likes are viewable by everyone" ON public.comment_likes;
CREATE POLICY "Comment likes are viewable by everyone" ON public.comment_likes
    FOR SELECT USING (true);

-- 인증된 사용자는 자신의 댓글 좋아요 추가/삭제 가능
DROP POLICY IF EXISTS "Users can manage own comment likes" ON public.comment_likes;
CREATE POLICY "Users can manage own comment likes" ON public.comment_likes
    FOR ALL USING (auth.uid() = user_id);

-- =================================================
-- 12. Follows 테이블 정책
-- =================================================

-- 모든 팔로우 관계 조회 가능
DROP POLICY IF EXISTS "Follow relationships are viewable by everyone" ON public.follows;
CREATE POLICY "Follow relationships are viewable by everyone" ON public.follows
    FOR SELECT USING (true);

-- 인증된 사용자는 자신의 팔로우 관계 관리 가능
DROP POLICY IF EXISTS "Users can manage own follows" ON public.follows;
CREATE POLICY "Users can manage own follows" ON public.follows
    FOR ALL USING (auth.uid() = follower_id);

-- =================================================
-- 13. Notifications 테이블 정책
-- =================================================

-- 사용자는 자신의 알림만 조회 가능
DROP POLICY IF EXISTS "Users can view own notifications" ON public.notifications;
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

-- 시스템에서 알림 생성 가능 (서비스 역할)
DROP POLICY IF EXISTS "Service role can create notifications" ON public.notifications;
CREATE POLICY "Service role can create notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

-- 사용자는 자신의 알림 상태 업데이트 가능 (읽음 처리 등)
DROP POLICY IF EXISTS "Users can update own notifications" ON public.notifications;
CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- 사용자는 자신의 알림 삭제 가능
DROP POLICY IF EXISTS "Users can delete own notifications" ON public.notifications;
CREATE POLICY "Users can delete own notifications" ON public.notifications
    FOR DELETE USING (auth.uid() = user_id);

-- =================================================
-- 14. 함수 레벨 보안 정책
-- =================================================

-- 알림 생성 함수 (트리거나 서버사이드에서 호출)
CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID,
    p_actor_id UUID,
    p_type TEXT,
    p_title TEXT,
    p_message TEXT,
    p_entity_type TEXT DEFAULT NULL,
    p_entity_id UUID DEFAULT NULL
)
RETURNS UUID
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO public.notifications (
        user_id, actor_id, type, title, message, entity_type, entity_id
    ) VALUES (
        p_user_id, p_actor_id, p_type, p_title, p_message, p_entity_type, p_entity_id
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$;

-- 팔로워들에게 알림 전송 함수
CREATE OR REPLACE FUNCTION notify_followers_on_new_content()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
    -- 새 콘텐츠가 발행되었을 때 팔로워들에게 알림
    IF NEW.status = 'published' AND (OLD IS NULL OR OLD.status != 'published') THEN
        INSERT INTO public.notifications (user_id, actor_id, type, title, message, entity_type, entity_id)
        SELECT 
            f.follower_id,
            NEW.author_id,
            'content',
            'New content from ' || u.name,
            u.name || ' published: ' || NEW.title,
            'content',
            NEW.id
        FROM public.follows f
        JOIN public.users u ON u.id = NEW.author_id
        WHERE f.following_id = NEW.author_id;
    END IF;
    
    RETURN NEW;
END;
$$;

-- 콘텐츠 발행 시 팔로워 알림 트리거
DROP TRIGGER IF EXISTS notify_followers_on_content_publish ON public.contents;
CREATE TRIGGER notify_followers_on_content_publish
    AFTER INSERT OR UPDATE ON public.contents
    FOR EACH ROW
    EXECUTE FUNCTION notify_followers_on_new_content();

-- 좋아요 시 알림 함수
CREATE OR REPLACE FUNCTION notify_on_like()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    content_author_id UUID;
    content_title TEXT;
    liker_name TEXT;
BEGIN
    -- 콘텐츠 작성자 정보 가져오기
    SELECT c.author_id, c.title INTO content_author_id, content_title
    FROM public.contents c WHERE c.id = NEW.content_id;
    
    -- 좋아요 한 사용자 이름 가져오기
    SELECT u.name INTO liker_name
    FROM public.users u WHERE u.id = NEW.user_id;
    
    -- 자신의 콘텐츠가 아닌 경우에만 알림
    IF content_author_id != NEW.user_id THEN
        PERFORM create_notification(
            content_author_id,
            NEW.user_id,
            'like',
            'Someone liked your content',
            liker_name || ' liked your content: ' || content_title,
            'content',
            NEW.content_id
        );
    END IF;
    
    RETURN NEW;
END;
$$;

-- 좋아요 알림 트리거
DROP TRIGGER IF EXISTS notify_on_content_like ON public.content_likes;
CREATE TRIGGER notify_on_content_like
    AFTER INSERT ON public.content_likes
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_like();

-- 댓글 시 알림 함수
CREATE OR REPLACE FUNCTION notify_on_comment()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    content_author_id UUID;
    content_title TEXT;
    commenter_name TEXT;
    parent_comment_author_id UUID;
BEGIN
    -- 콘텐츠 작성자 정보 가져오기
    SELECT c.author_id, c.title INTO content_author_id, content_title
    FROM public.contents c WHERE c.id = NEW.content_id;
    
    -- 댓글 작성자 이름 가져오기
    SELECT u.name INTO commenter_name
    FROM public.users u WHERE u.id = NEW.user_id;
    
    -- 콘텐츠 작성자에게 알림 (자신의 콘텐츠가 아닌 경우)
    IF content_author_id != NEW.user_id THEN
        PERFORM create_notification(
            content_author_id,
            NEW.user_id,
            'comment',
            'New comment on your content',
            commenter_name || ' commented on: ' || content_title,
            'content',
            NEW.content_id
        );
    END IF;
    
    -- 답글인 경우 원 댓글 작성자에게도 알림
    IF NEW.parent_comment_id IS NOT NULL THEN
        SELECT c.user_id INTO parent_comment_author_id
        FROM public.comments c WHERE c.id = NEW.parent_comment_id;
        
        IF parent_comment_author_id != NEW.user_id AND parent_comment_author_id != content_author_id THEN
            PERFORM create_notification(
                parent_comment_author_id,
                NEW.user_id,
                'reply',
                'Someone replied to your comment',
                commenter_name || ' replied to your comment',
                'comment',
                NEW.parent_comment_id
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;

-- 댓글 알림 트리거
DROP TRIGGER IF EXISTS notify_on_new_comment ON public.comments;
CREATE TRIGGER notify_on_new_comment
    AFTER INSERT ON public.comments
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_comment();

-- 팔로우 시 알림 함수
CREATE OR REPLACE FUNCTION notify_on_follow()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    follower_name TEXT;
BEGIN
    -- 팔로워 이름 가져오기
    SELECT u.name INTO follower_name
    FROM public.users u WHERE u.id = NEW.follower_id;
    
    -- 팔로우 당한 사용자에게 알림
    PERFORM create_notification(
        NEW.following_id,
        NEW.follower_id,
        'follow',
        'New follower',
        follower_name || ' started following you',
        'user',
        NEW.follower_id
    );
    
    RETURN NEW;
END;
$$;

-- 팔로우 알림 트리거
DROP TRIGGER IF EXISTS notify_on_new_follow ON public.follows;
CREATE TRIGGER notify_on_new_follow
    AFTER INSERT ON public.follows
    FOR EACH ROW
    EXECUTE FUNCTION notify_on_follow();