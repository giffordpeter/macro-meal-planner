(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[931],{2785:function(e,t,r){Promise.resolve().then(r.bind(r,6610))},6610:function(e,t,r){"use strict";r.r(t),r.d(t,{default:function(){return X}});var n=r(7437),o=r(2265);function l(e,[t,r]){return Math.min(r,Math.max(t,e))}function i(e,t,{checkForDefaultPrevented:r=!0}={}){return function(n){if(e?.(n),!1===r||!n.defaultPrevented)return t?.(n)}}function a(e,t){if("function"==typeof e)return e(t);null!=e&&(e.current=t)}function s(...e){return t=>{let r=!1,n=e.map(e=>{let n=a(e,t);return r||"function"!=typeof n||(r=!0),n});if(r)return()=>{for(let t=0;t<n.length;t++){let r=n[t];"function"==typeof r?r():a(e[t],null)}}}}function u(...e){return o.useCallback(s(...e),e)}function c(e,t=[]){let r=[],l=()=>{let t=r.map(e=>o.createContext(e));return function(r){let n=r?.[e]||t;return o.useMemo(()=>({[`__scope${e}`]:{...r,[e]:n}}),[r,n])}};return l.scopeName=e,[function(t,l){let i=o.createContext(l),a=r.length;r=[...r,l];let s=t=>{let{scope:r,children:l,...s}=t,u=r?.[e]?.[a]||i,c=o.useMemo(()=>s,Object.values(s));return(0,n.jsx)(u.Provider,{value:c,children:l})};return s.displayName=t+"Provider",[s,function(r,n){let s=n?.[e]?.[a]||i,u=o.useContext(s);if(u)return u;if(void 0!==l)return l;throw Error(`\`${r}\` must be used within \`${t}\``)}]},function(...e){let t=e[0];if(1===e.length)return t;let r=()=>{let r=e.map(e=>({useScope:e(),scopeName:e.scopeName}));return function(e){let n=r.reduce((t,{useScope:r,scopeName:n})=>{let o=r(e)[`__scope${n}`];return{...t,...o}},{});return o.useMemo(()=>({[`__scope${t.scopeName}`]:n}),[n])}};return r.scopeName=t.scopeName,r}(l,...t)]}function d(e){let t=o.useRef(e);return o.useEffect(()=>{t.current=e}),o.useMemo(()=>(...e)=>t.current?.(...e),[])}var f=o.createContext(void 0),m=globalThis?.document?o.useLayoutEffect:()=>{};r(4887);var p=o.forwardRef((e,t)=>{let{children:r,...l}=e,i=o.Children.toArray(r),a=i.find(b);if(a){let e=a.props.children,r=i.map(t=>t!==a?t:o.Children.count(e)>1?o.Children.only(null):o.isValidElement(e)?e.props.children:null);return(0,n.jsx)(h,{...l,ref:t,children:o.isValidElement(e)?o.cloneElement(e,void 0,r):null})}return(0,n.jsx)(h,{...l,ref:t,children:r})});p.displayName="Slot";var h=o.forwardRef((e,t)=>{let{children:r,...n}=e;if(o.isValidElement(r)){let e,l;let i=(e=Object.getOwnPropertyDescriptor(r.props,"ref")?.get)&&"isReactWarning"in e&&e.isReactWarning?r.ref:(e=Object.getOwnPropertyDescriptor(r,"ref")?.get)&&"isReactWarning"in e&&e.isReactWarning?r.props.ref:r.props.ref||r.ref;return o.cloneElement(r,{...function(e,t){let r={...t};for(let n in t){let o=e[n],l=t[n];/^on[A-Z]/.test(n)?o&&l?r[n]=(...e)=>{l(...e),o(...e)}:o&&(r[n]=o):"style"===n?r[n]={...o,...l}:"className"===n&&(r[n]=[o,l].filter(Boolean).join(" "))}return{...e,...r}}(n,r.props),ref:t?s(t,i):i})}return o.Children.count(r)>1?o.Children.only(null):null});h.displayName="SlotClone";var x=({children:e})=>(0,n.jsx)(n.Fragment,{children:e});function b(e){return o.isValidElement(e)&&e.type===x}var g=["a","button","div","form","h2","h3","img","input","label","li","nav","ol","p","span","svg","ul"].reduce((e,t)=>{let r=o.forwardRef((e,r)=>{let{asChild:o,...l}=e,i=o?p:t;return"undefined"!=typeof window&&(window[Symbol.for("radix-ui")]=!0),(0,n.jsx)(i,{...l,ref:r})});return r.displayName=`Primitive.${t}`,{...e,[t]:r}},{}),v=["PageUp","PageDown"],y=["ArrowUp","ArrowDown","ArrowLeft","ArrowRight"],w={"from-left":["Home","PageDown","ArrowDown","ArrowLeft"],"from-right":["Home","PageDown","ArrowDown","ArrowRight"],"from-bottom":["Home","PageDown","ArrowDown","ArrowLeft"],"from-top":["Home","PageDown","ArrowUp","ArrowLeft"]},j="Slider",[S,N,R]=function(e){let t=e+"CollectionProvider",[r,l]=c(t),[i,a]=r(t,{collectionRef:{current:null},itemMap:new Map}),s=e=>{let{scope:t,children:r}=e,l=o.useRef(null),a=o.useRef(new Map).current;return(0,n.jsx)(i,{scope:t,itemMap:a,collectionRef:l,children:r})};s.displayName=t;let d=e+"CollectionSlot",f=o.forwardRef((e,t)=>{let{scope:r,children:o}=e,l=u(t,a(d,r).collectionRef);return(0,n.jsx)(p,{ref:l,children:o})});f.displayName=d;let m=e+"CollectionItemSlot",h="data-radix-collection-item",x=o.forwardRef((e,t)=>{let{scope:r,children:l,...i}=e,s=o.useRef(null),c=u(t,s),d=a(m,r);return o.useEffect(()=>(d.itemMap.set(s,{ref:s,...i}),()=>void d.itemMap.delete(s))),(0,n.jsx)(p,{[h]:"",ref:c,children:l})});return x.displayName=m,[{Provider:s,Slot:f,ItemSlot:x},function(t){let r=a(e+"CollectionConsumer",t);return o.useCallback(()=>{let e=r.collectionRef.current;if(!e)return[];let t=Array.from(e.querySelectorAll(`[${h}]`));return Array.from(r.itemMap.values()).sort((e,r)=>t.indexOf(e.ref.current)-t.indexOf(r.ref.current))},[r.collectionRef,r.itemMap])},l]}(j),[_,E]=c(j,[R]),[M,C]=_(j),P=o.forwardRef((e,t)=>{let{name:r,min:a=0,max:s=100,step:u=1,orientation:c="horizontal",disabled:f=!1,minStepsBetweenThumbs:m=0,defaultValue:p=[a],value:h,onValueChange:x=()=>{},onValueCommit:b=()=>{},inverted:g=!1,form:w,...j}=e,N=o.useRef(new Set),R=o.useRef(0),_="horizontal"===c?A:O,[E=[],C]=function({prop:e,defaultProp:t,onChange:r=()=>{}}){let[n,l]=function({defaultProp:e,onChange:t}){let r=o.useState(e),[n]=r,l=o.useRef(n),i=d(t);return o.useEffect(()=>{l.current!==n&&(i(n),l.current=n)},[n,l,i]),r}({defaultProp:t,onChange:r}),i=void 0!==e,a=i?e:n,s=d(r);return[a,o.useCallback(t=>{if(i){let r="function"==typeof t?t(e):t;r!==e&&s(r)}else l(t)},[i,e,l,s])]}({prop:h,defaultProp:p,onChange:e=>{let t=[...N.current];t[R.current]?.focus(),x(e)}}),P=o.useRef(E);function D(e,t,{commit:r}={commit:!1}){let n=(String(u).split(".")[1]||"").length,o=l(function(e,t){let r=Math.pow(10,t);return Math.round(e*r)/r}(Math.round((e-a)/u)*u+a,n),[a,s]);C((e=[])=>{var n,l;let i=function(e=[],t,r){let n=[...e];return n[r]=t,n.sort((e,t)=>e-t)}(e,o,t);if(n=i,!(!((l=m*u)>0)||Math.min(...n.slice(0,-1).map((e,t)=>n[t+1]-e))>=l))return e;{R.current=i.indexOf(o);let t=String(i)!==String(e);return t&&r&&b(i),t?i:e}})}return(0,n.jsx)(M,{scope:e.__scopeSlider,name:r,disabled:f,min:a,max:s,valueIndexToChangeRef:R,thumbs:N.current,values:E,orientation:c,form:w,children:(0,n.jsx)(S.Provider,{scope:e.__scopeSlider,children:(0,n.jsx)(S.Slot,{scope:e.__scopeSlider,children:(0,n.jsx)(_,{"aria-disabled":f,"data-disabled":f?"":void 0,...j,ref:t,onPointerDown:i(j.onPointerDown,()=>{f||(P.current=E)}),min:a,max:s,inverted:g,onSlideStart:f?void 0:function(e){let t=function(e,t){if(1===e.length)return 0;let r=e.map(e=>Math.abs(e-t));return r.indexOf(Math.min(...r))}(E,e);D(e,t)},onSlideMove:f?void 0:function(e){D(e,R.current)},onSlideEnd:f?void 0:function(){let e=P.current[R.current];E[R.current]!==e&&b(E)},onHomeKeyDown:()=>!f&&D(a,0,{commit:!0}),onEndKeyDown:()=>!f&&D(s,E.length-1,{commit:!0}),onStepKeyDown:({event:e,direction:t})=>{if(!f){let r=v.includes(e.key)||e.shiftKey&&y.includes(e.key),n=R.current;D(E[n]+u*(r?10:1)*t,n,{commit:!0})}}})})})})});P.displayName=j;var[D,k]=_(j,{startEdge:"left",endEdge:"right",size:"width",direction:1}),A=o.forwardRef((e,t)=>{let{min:r,max:l,dir:i,inverted:a,onSlideStart:s,onSlideMove:c,onSlideEnd:d,onStepKeyDown:m,...p}=e,[h,x]=o.useState(null),b=u(t,e=>x(e)),g=o.useRef(void 0),v=function(e){let t=o.useContext(f);return e||t||"ltr"}(i),y="ltr"===v,j=y&&!a||!y&&a;function S(e){let t=g.current||h.getBoundingClientRect(),n=U([0,t.width],j?[r,l]:[l,r]);return g.current=t,n(e-t.left)}return(0,n.jsx)(D,{scope:e.__scopeSlider,startEdge:j?"left":"right",endEdge:j?"right":"left",direction:j?1:-1,size:"width",children:(0,n.jsx)(I,{dir:v,"data-orientation":"horizontal",...p,ref:b,style:{...p.style,"--radix-slider-thumb-transform":"translateX(-50%)"},onSlideStart:e=>{let t=S(e.clientX);s?.(t)},onSlideMove:e=>{let t=S(e.clientX);c?.(t)},onSlideEnd:()=>{g.current=void 0,d?.()},onStepKeyDown:e=>{let t=w[j?"from-left":"from-right"].includes(e.key);m?.({event:e,direction:t?-1:1})}})})}),O=o.forwardRef((e,t)=>{let{min:r,max:l,inverted:i,onSlideStart:a,onSlideMove:s,onSlideEnd:c,onStepKeyDown:d,...f}=e,m=o.useRef(null),p=u(t,m),h=o.useRef(void 0),x=!i;function b(e){let t=h.current||m.current.getBoundingClientRect(),n=U([0,t.height],x?[l,r]:[r,l]);return h.current=t,n(e-t.top)}return(0,n.jsx)(D,{scope:e.__scopeSlider,startEdge:x?"bottom":"top",endEdge:x?"top":"bottom",size:"height",direction:x?1:-1,children:(0,n.jsx)(I,{"data-orientation":"vertical",...f,ref:p,style:{...f.style,"--radix-slider-thumb-transform":"translateY(50%)"},onSlideStart:e=>{let t=b(e.clientY);a?.(t)},onSlideMove:e=>{let t=b(e.clientY);s?.(t)},onSlideEnd:()=>{h.current=void 0,c?.()},onStepKeyDown:e=>{let t=w[x?"from-bottom":"from-top"].includes(e.key);d?.({event:e,direction:t?-1:1})}})})}),I=o.forwardRef((e,t)=>{let{__scopeSlider:r,onSlideStart:o,onSlideMove:l,onSlideEnd:a,onHomeKeyDown:s,onEndKeyDown:u,onStepKeyDown:c,...d}=e,f=C(j,r);return(0,n.jsx)(g.span,{...d,ref:t,onKeyDown:i(e.onKeyDown,e=>{"Home"===e.key?(s(e),e.preventDefault()):"End"===e.key?(u(e),e.preventDefault()):v.concat(y).includes(e.key)&&(c(e),e.preventDefault())}),onPointerDown:i(e.onPointerDown,e=>{let t=e.target;t.setPointerCapture(e.pointerId),e.preventDefault(),f.thumbs.has(t)?t.focus():o(e)}),onPointerMove:i(e.onPointerMove,e=>{e.target.hasPointerCapture(e.pointerId)&&l(e)}),onPointerUp:i(e.onPointerUp,e=>{let t=e.target;t.hasPointerCapture(e.pointerId)&&(t.releasePointerCapture(e.pointerId),a(e))})})}),$="SliderTrack",z=o.forwardRef((e,t)=>{let{__scopeSlider:r,...o}=e,l=C($,r);return(0,n.jsx)(g.span,{"data-disabled":l.disabled?"":void 0,"data-orientation":l.orientation,...o,ref:t})});z.displayName=$;var F="SliderRange",L=o.forwardRef((e,t)=>{let{__scopeSlider:r,...l}=e,i=C(F,r),a=k(F,r),s=u(t,o.useRef(null)),c=i.values.length,d=i.values.map(e=>V(e,i.min,i.max));return(0,n.jsx)(g.span,{"data-orientation":i.orientation,"data-disabled":i.disabled?"":void 0,...l,ref:s,style:{...e.style,[a.startEdge]:(c>1?Math.min(...d):0)+"%",[a.endEdge]:100-Math.max(...d)+"%"}})});L.displayName=F;var H="SliderThumb",T=o.forwardRef((e,t)=>{let r=N(e.__scopeSlider),[l,i]=o.useState(null),a=u(t,e=>i(e)),s=o.useMemo(()=>l?r().findIndex(e=>e.ref.current===l):-1,[r,l]);return(0,n.jsx)(B,{...e,ref:a,index:s})}),B=o.forwardRef((e,t)=>{var r;let{__scopeSlider:l,index:a,name:s,...c}=e,d=C(H,l),f=k(H,l),[p,h]=o.useState(null),x=u(t,e=>h(e)),b=!p||d.form||!!p.closest("form"),v=function(e){let[t,r]=o.useState(void 0);return m(()=>{if(e){r({width:e.offsetWidth,height:e.offsetHeight});let t=new ResizeObserver(t=>{let n,o;if(!Array.isArray(t)||!t.length)return;let l=t[0];if("borderBoxSize"in l){let e=l.borderBoxSize,t=Array.isArray(e)?e[0]:e;n=t.inlineSize,o=t.blockSize}else n=e.offsetWidth,o=e.offsetHeight;r({width:n,height:o})});return t.observe(e,{box:"border-box"}),()=>t.unobserve(e)}r(void 0)},[e]),t}(p),y=d.values[a],w=void 0===y?0:V(y,d.min,d.max),j=(r=d.values.length)>2?`Value ${a+1} of ${r}`:2===r?["Minimum","Maximum"][a]:void 0,N=v?.[f.size],R=N?function(e,t,r){let n=e/2,o=U([0,50],[0,n]);return(n-o(t)*r)*r}(N,w,f.direction):0;return o.useEffect(()=>{if(p)return d.thumbs.add(p),()=>{d.thumbs.delete(p)}},[p,d.thumbs]),(0,n.jsxs)("span",{style:{transform:"var(--radix-slider-thumb-transform)",position:"absolute",[f.startEdge]:`calc(${w}% + ${R}px)`},children:[(0,n.jsx)(S.ItemSlot,{scope:e.__scopeSlider,children:(0,n.jsx)(g.span,{role:"slider","aria-label":e["aria-label"]||j,"aria-valuemin":d.min,"aria-valuenow":y,"aria-valuemax":d.max,"aria-orientation":d.orientation,"data-orientation":d.orientation,"data-disabled":d.disabled?"":void 0,tabIndex:d.disabled?void 0:0,...c,ref:x,style:void 0===y?{display:"none"}:e.style,onFocus:i(e.onFocus,()=>{d.valueIndexToChangeRef.current=a})})}),b&&(0,n.jsx)(K,{name:s??(d.name?d.name+(d.values.length>1?"[]":""):void 0),form:d.form,value:y},a)]})});T.displayName=H;var K=e=>{let{value:t,...r}=e,l=o.useRef(null),i=function(e){let t=o.useRef({value:e,previous:e});return o.useMemo(()=>(t.current.value!==e&&(t.current.previous=t.current.value,t.current.value=e),t.current.previous),[e])}(t);return o.useEffect(()=>{let e=l.current,r=Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,"value").set;if(i!==t&&r){let n=new Event("input",{bubbles:!0});r.call(e,t),e.dispatchEvent(n)}},[i,t]),(0,n.jsx)("input",{style:{display:"none"},...r,ref:l,defaultValue:t})};function V(e,t,r){return l(100/(r-t)*(e-t),[0,100])}function U(e,t){return r=>{if(e[0]===e[1]||t[0]===t[1])return t[0];let n=(t[1]-t[0])/(e[1]-e[0]);return t[0]+n*(r-e[0])}}var W=o.forwardRef((e,t)=>(0,n.jsx)(g.label,{...e,ref:t,onMouseDown:t=>{t.target.closest("button, input, select, textarea")||(e.onMouseDown?.(t),!t.defaultPrevented&&t.detail>1&&t.preventDefault())}}));function Y(){let[e,t]=(0,o.useState)({calories:2e3,protein:150,carbs:200,fat:67}),[r,l]=(0,o.useState)(100),i=(e,t,r)=>4*e+4*t+9*r,a=e=>{let r=e/100;l(e),t(e=>({calories:Math.round(e.calories*r),protein:Math.round(e.protein*r),carbs:Math.round(e.carbs*r),fat:Math.round(e.fat*r)}))},s=(e,r)=>{let n=Math.max(0,r);t(t=>{let r={...t,[e]:n};return"calories"!==e&&(r.calories=i(r.protein,r.carbs,r.fat)),r})},u=((e,t,r)=>{let n=i(e,t,r);return{protein:400*e/n,carbs:400*t/n,fat:900*r/n}})(e.protein,e.carbs,e.fat),c={protein:"#FF6B42",carbs:"#636366",fat:"#8E8E93"};return(0,n.jsxs)("div",{className:"max-w-2xl mx-auto bg-white rounded-lg shadow-sm p-6",children:[(0,n.jsxs)("div",{className:"mb-8",children:[(0,n.jsx)("h2",{className:"text-lg font-semibold text-gray-900 mb-4",children:"Daily Targets"}),(0,n.jsxs)("div",{className:"flex flex-col sm:flex-row gap-4 items-center",children:[(0,n.jsxs)("div",{className:"flex-grow w-full sm:w-2/3",children:[(0,n.jsxs)(P,{className:"relative flex items-center select-none touch-none w-full h-5",value:[r],onValueChange:e=>{let[t]=e;return a(t)},min:50,max:150,step:1,children:[(0,n.jsx)(z,{className:"bg-gray-200 relative grow rounded-full h-1",children:(0,n.jsx)(L,{className:"absolute bg-blue-500 rounded-full h-full"})}),(0,n.jsx)(T,{className:"block w-5 h-5 bg-blue-500 rounded-full hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2","aria-label":"Scale percentage"})]}),(0,n.jsxs)("div",{className:"flex justify-between mt-1 text-sm text-gray-600",children:[(0,n.jsx)("span",{children:"50%"}),(0,n.jsx)("span",{children:"100%"}),(0,n.jsx)("span",{children:"150%"})]})]}),(0,n.jsxs)("div",{className:"w-full sm:w-1/3",children:[(0,n.jsx)(W,{className:"block text-sm font-medium text-gray-700 mb-1",htmlFor:"calories",children:"Calories"}),(0,n.jsx)("input",{id:"calories",type:"number",value:e.calories,onChange:e=>s("calories",Number(e.target.value)),className:"block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"})]})]})]}),(0,n.jsx)("hr",{className:"my-6 border-gray-200"}),(0,n.jsx)("div",{className:"space-y-6",children:[{name:"Protein",key:"protein"},{name:"Carbs",key:"carbs"},{name:"Fat",key:"fat"}].map(t=>{let{name:r,key:o}=t;return(0,n.jsxs)("div",{children:[(0,n.jsxs)("div",{className:"flex justify-between items-center mb-2",children:[(0,n.jsx)(W,{className:"text-sm font-semibold text-gray-900",htmlFor:o,children:r}),(0,n.jsxs)("span",{className:"inline-flex items-center px-2.5 py-0.5 rounded-md text-sm font-medium bg-gray-100 text-gray-800",children:[e[o],"g (",Math.round(u[o]),"%)"]})]}),(0,n.jsxs)("div",{className:"flex items-center gap-4",children:[(0,n.jsx)("div",{className:"flex-grow",children:(0,n.jsxs)(P,{className:"relative flex items-center select-none touch-none w-full h-5",value:[e[o]],onValueChange:e=>{let[t]=e;return s(o,t)},min:0,max:"fat"===o?200:400,step:1,children:[(0,n.jsx)(z,{className:"bg-gray-200 relative grow rounded-full h-1",children:(0,n.jsx)(L,{className:"absolute rounded-full h-full",style:{backgroundColor:c[o]}})}),(0,n.jsx)(T,{className:"block w-5 h-5 rounded-full hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2",style:{backgroundColor:c[o]},"aria-label":"".concat(r," value")})]})}),(0,n.jsx)("input",{id:o,type:"number",value:e[o],onChange:e=>s(o,Number(e.target.value)),className:"w-20 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm bg-gray-50"})]})]},o)})})]})}function X(){return(0,n.jsx)("div",{className:"min-h-screen bg-gray-50",children:(0,n.jsx)("div",{className:"max-w-4xl mx-auto px-4",children:(0,n.jsxs)("div",{className:"py-8",children:[(0,n.jsx)("h1",{className:"text-3xl font-bold text-center mb-8 text-blue-600 tracking-tight",children:"Macro Builder"}),(0,n.jsx)(Y,{})]})})})}W.displayName="Label"},622:function(e,t,r){"use strict";var n=r(2265),o=Symbol.for("react.element"),l=Symbol.for("react.fragment"),i=Object.prototype.hasOwnProperty,a=n.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,s={key:!0,ref:!0,__self:!0,__source:!0};function u(e,t,r){var n,l={},u=null,c=null;for(n in void 0!==r&&(u=""+r),void 0!==t.key&&(u=""+t.key),void 0!==t.ref&&(c=t.ref),t)i.call(t,n)&&!s.hasOwnProperty(n)&&(l[n]=t[n]);if(e&&e.defaultProps)for(n in t=e.defaultProps)void 0===l[n]&&(l[n]=t[n]);return{$$typeof:o,type:e,key:u,ref:c,props:l,_owner:a.current}}t.Fragment=l,t.jsx=u,t.jsxs=u},7437:function(e,t,r){"use strict";e.exports=r(622)}},function(e){e.O(0,[971,938,744],function(){return e(e.s=2785)}),_N_E=e.O()}]);