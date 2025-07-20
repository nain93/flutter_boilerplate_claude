-- =================================================
-- 콘텐츠 공유 앱 확장 데이터베이스 스키마
-- Supabase + Flutter Clean Architecture 지원
-- =================================================

-- 1. 기존 테이블 수정 (Users)
-- =================================================
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS profile_image_url TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS followers_count INTEGER DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS following_count INTEGER DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT false;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- 2. 기존 테이블 수정 (Contents)
-- =================================================
ALTER TABLE public.contents ADD COLUMN IF NOT EXISTS content_type TEXT DEFAULT 'article' CHECK (content_type IN ('article', 'image', 'video', 'audio'));
ALTER TABLE public.contents ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived'));
ALTER TABLE public.contents ADD COLUMN IF NOT EXISTS comments_count INTEGER DEFAULT 0;
ALTER TABLE public.contents ADD COLUMN IF NOT EXISTS bookmarks_count INTEGER DEFAULT 0;
ALTER TABLE public.contents ADD COLUMN IF NOT EXISTS shares_count INTEGER DEFAULT 0;

-- 3. 카테고리 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon_url TEXT,
    color_code TEXT DEFAULT '#6366f1',
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 태그 테이블 
-- =================================================
CREATE TABLE IF NOT EXISTS public.tags (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 콘텐츠-카테고리 연결 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.content_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content_id UUID NOT NULL REFERENCES public.contents(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(content_id, category_id)
);

-- 6. 콘텐츠-태그 연결 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.content_tags (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content_id UUID NOT NULL REFERENCES public.contents(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES public.tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(content_id, tag_id)
);

-- 7. 콘텐츠 좋아요 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.content_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content_id UUID NOT NULL REFERENCES public.contents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(content_id, user_id)
);

-- 8. 콘텐츠 북마크 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.content_bookmarks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content_id UUID NOT NULL REFERENCES public.contents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(content_id, user_id)
);

-- 9. 댓글 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.comments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    content_id UUID NOT NULL REFERENCES public.contents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    likes_count INTEGER DEFAULT 0,
    replies_count INTEGER DEFAULT 0,
    is_edited BOOLEAN DEFAULT false,
    is_deleted BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. 댓글 좋아요 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.comment_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    comment_id UUID NOT NULL REFERENCES public.comments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(comment_id, user_id)
);

-- 11. 팔로우 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.follows (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    follower_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(follower_id, following_id),
    CHECK (follower_id != following_id)
);

-- 12. 알림 테이블
-- =================================================
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    actor_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('like', 'comment', 'follow', 'mention', 'bookmark', 'reply')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    entity_type TEXT CHECK (entity_type IN ('content', 'comment', 'user')),
    entity_id UUID,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================
-- 인덱스 생성 (성능 최적화)
-- =================================================

-- Contents 관련 인덱스
CREATE INDEX IF NOT EXISTS idx_contents_author_id ON public.contents(author_id);
CREATE INDEX IF NOT EXISTS idx_contents_created_at ON public.contents(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contents_status ON public.contents(status);
CREATE INDEX IF NOT EXISTS idx_contents_content_type ON public.contents(content_type);

-- 좋아요/북마크 인덱스
CREATE INDEX IF NOT EXISTS idx_content_likes_content_id ON public.content_likes(content_id);
CREATE INDEX IF NOT EXISTS idx_content_likes_user_id ON public.content_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_content_bookmarks_content_id ON public.content_bookmarks(content_id);
CREATE INDEX IF NOT EXISTS idx_content_bookmarks_user_id ON public.content_bookmarks(user_id);

-- 댓글 인덱스
CREATE INDEX IF NOT EXISTS idx_comments_content_id ON public.comments(content_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON public.comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent_id ON public.comments(parent_comment_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON public.comments(created_at DESC);

-- 팔로우 인덱스
CREATE INDEX IF NOT EXISTS idx_follows_follower_id ON public.follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following_id ON public.follows(following_id);

-- 알림 인덱스
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

-- 카테고리/태그 인덱스
CREATE INDEX IF NOT EXISTS idx_content_categories_content_id ON public.content_categories(content_id);
CREATE INDEX IF NOT EXISTS idx_content_categories_category_id ON public.content_categories(category_id);
CREATE INDEX IF NOT EXISTS idx_content_tags_content_id ON public.content_tags(content_id);
CREATE INDEX IF NOT EXISTS idx_content_tags_tag_id ON public.content_tags(tag_id);

-- =================================================
-- 트리거 함수 정의
-- =================================================

-- 업데이트 시간 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 카운터 업데이트 함수들
CREATE OR REPLACE FUNCTION update_content_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.contents 
        SET likes = likes + 1 
        WHERE id = NEW.content_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.contents 
        SET likes = likes - 1 
        WHERE id = OLD.content_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_content_bookmarks_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.contents 
        SET bookmarks_count = bookmarks_count + 1 
        WHERE id = NEW.content_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.contents 
        SET bookmarks_count = bookmarks_count - 1 
        WHERE id = OLD.content_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_comments_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.contents 
        SET comments_count = comments_count + 1 
        WHERE id = NEW.content_id;
        
        -- 답글인 경우 부모 댓글의 답글 수도 증가
        IF NEW.parent_comment_id IS NOT NULL THEN
            UPDATE public.comments 
            SET replies_count = replies_count + 1 
            WHERE id = NEW.parent_comment_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.contents 
        SET comments_count = comments_count - 1 
        WHERE id = OLD.content_id;
        
        -- 답글인 경우 부모 댓글의 답글 수도 감소
        IF OLD.parent_comment_id IS NOT NULL THEN
            UPDATE public.comments 
            SET replies_count = replies_count - 1 
            WHERE id = OLD.parent_comment_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_comment_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.comments 
        SET likes_count = likes_count + 1 
        WHERE id = NEW.comment_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.comments 
        SET likes_count = likes_count - 1 
        WHERE id = OLD.comment_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_follow_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- 팔로워 수 증가
        UPDATE public.users 
        SET followers_count = followers_count + 1 
        WHERE id = NEW.following_id;
        
        -- 팔로잉 수 증가
        UPDATE public.users 
        SET following_count = following_count + 1 
        WHERE id = NEW.follower_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- 팔로워 수 감소
        UPDATE public.users 
        SET followers_count = followers_count - 1 
        WHERE id = OLD.following_id;
        
        -- 팔로잉 수 감소
        UPDATE public.users 
        SET following_count = following_count - 1 
        WHERE id = OLD.follower_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_tag_usage_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.tags 
        SET usage_count = usage_count + 1 
        WHERE id = NEW.tag_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.tags 
        SET usage_count = usage_count - 1 
        WHERE id = OLD.tag_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- =================================================
-- 트리거 생성
-- =================================================

-- 업데이트 시간 자동 갱신 트리거
DROP TRIGGER IF EXISTS update_users_updated_at ON public.users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON public.users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_contents_updated_at ON public.contents;
CREATE TRIGGER update_contents_updated_at 
    BEFORE UPDATE ON public.contents 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_comments_updated_at ON public.comments;
CREATE TRIGGER update_comments_updated_at 
    BEFORE UPDATE ON public.comments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_categories_updated_at ON public.categories;
CREATE TRIGGER update_categories_updated_at 
    BEFORE UPDATE ON public.categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 카운터 업데이트 트리거
DROP TRIGGER IF EXISTS content_likes_count_trigger ON public.content_likes;
CREATE TRIGGER content_likes_count_trigger 
    AFTER INSERT OR DELETE ON public.content_likes 
    FOR EACH ROW EXECUTE FUNCTION update_content_likes_count();

DROP TRIGGER IF EXISTS content_bookmarks_count_trigger ON public.content_bookmarks;
CREATE TRIGGER content_bookmarks_count_trigger 
    AFTER INSERT OR DELETE ON public.content_bookmarks 
    FOR EACH ROW EXECUTE FUNCTION update_content_bookmarks_count();

DROP TRIGGER IF EXISTS comments_count_trigger ON public.comments;
CREATE TRIGGER comments_count_trigger 
    AFTER INSERT OR DELETE ON public.comments 
    FOR EACH ROW EXECUTE FUNCTION update_comments_count();

DROP TRIGGER IF EXISTS comment_likes_count_trigger ON public.comment_likes;
CREATE TRIGGER comment_likes_count_trigger 
    AFTER INSERT OR DELETE ON public.comment_likes 
    FOR EACH ROW EXECUTE FUNCTION update_comment_likes_count();

DROP TRIGGER IF EXISTS follow_counts_trigger ON public.follows;
CREATE TRIGGER follow_counts_trigger 
    AFTER INSERT OR DELETE ON public.follows 
    FOR EACH ROW EXECUTE FUNCTION update_follow_counts();

DROP TRIGGER IF EXISTS tag_usage_count_trigger ON public.content_tags;
CREATE TRIGGER tag_usage_count_trigger 
    AFTER INSERT OR DELETE ON public.content_tags 
    FOR EACH ROW EXECUTE FUNCTION update_tag_usage_count();